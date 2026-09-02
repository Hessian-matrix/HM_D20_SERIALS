#!/usr/bin/env bash
# 黑森矩阵 RTK：Jetson GPIO UART 配置与串口检查工具
set -u
STATE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hm-rtk"
PORT_FILE="$STATE_DIR/serial_port"
RULE_FILE=/etc/udev/rules.d/99-hm-rtk-uart.rules

say(){ printf '\n%s\n' "$*"; }
die(){ printf '\n错误：%s\n' "$*" >&2; exit 1; }
ask(){ local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]; }
user_name(){ [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]] && printf '%s' "$SUDO_USER" || printf '%s' "$USER"; }

ports(){
  PORTS=(); local p
  for p in /dev/ttyTHS* /dev/ttyUSB* /dev/ttyACM*; do
    [[ -e "$p" ]] || continue
    case " ${PORTS[*]} " in *" $p "*) ;; *) PORTS+=("$p");; esac
  done
}
choose_port(){
  ports; ((${#PORTS[@]})) || die '没有发现 ttyTHS/USB/ACM 串口。'
  say '串口候选：'; local i n
  for i in "${!PORTS[@]}"; do printf '%d) %s\n' "$((i+1))" "${PORTS[$i]}"; done
  read -r -p '请选择端口编号（默认 1）： ' n; [[ "$n" =~ ^[0-9]+$ ]] || n=1
  ((n>=1 && n<=${#PORTS[@]})) || die '编号无效。'
  mkdir -p -- "$STATE_DIR"; printf '%s\n' "${PORTS[$((n-1))]}" >"$PORT_FILE"
  printf '已保存端口：%s\n' "${PORTS[$((n-1))]}"
}
gpio_port(){
  [[ -e /dev/ttyTHS1 ]] && { printf /dev/ttyTHS1; return; }
  local a=() p; for p in /dev/ttyTHS*; do [[ -e "$p" ]] && a+=("$p"); done
  ((${#a[@]}==1)) && printf '%s' "${a[0]}"
}
configure(){
  local p u base; p="$(gpio_port)"; u="$(user_name)"; sudo -v || die 'sudo 验证失败。'
  say '将执行：禁用 nvgetty/getty，加入 dialout，并为 GPIO UART 设置持久化权限。不会安装 ROS 或修改设备树。'
  ask '确认执行吗？' || return
  sudo systemctl disable --now nvgetty 2>/dev/null || true
  sudo usermod -aG dialout "$u"
  if [[ -n "$p" ]]; then
    base="$(basename "$p")"
    sudo systemctl disable --now "serial-getty@${base}.service" 2>/dev/null || true
    printf 'KERNEL=="%s", GROUP="dialout", MODE="0660"\n' "$base" | sudo tee "$RULE_FILE" >/dev/null
    sudo udevadm control --reload-rules 2>/dev/null || true; sudo udevadm trigger --name-match="$base" 2>/dev/null || true
    mkdir -p -- "$STATE_DIR"; printf '%s\n' "$p" >"$PORT_FILE"
    printf 'GPIO UART：%s\n' "$p"
  else
    echo '未能自动确定 GPIO UART，请使用选项 2 选择端口。'
  fi
  echo "用户 $u 已加入 dialout；请重新登录后再读取串口。"
}
read_data(){
  local p saved; p="${1:-}"; [[ -n "$p" ]] || { [[ -s "$PORT_FILE" ]] && p="$(head -n1 "$PORT_FILE")" || p=/dev/ttyTHS1; }
  [[ -e "$p" ]] || die "串口不存在：$p"
  saved="$(stty -g -F "$p" 2>/dev/null || true)"; [[ -n "$saved" ]] || die '无法打开串口，请检查权限和占用。'
  stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts || die '无法配置串口。'
  trap 'stty -F "$p" "$saved" 2>/dev/null || true; printf "\n已恢复串口参数。\n"' EXIT INT TERM
  say "正在读取 $p，按 Ctrl+C 退出。NMEA 可读，UBX 二进制可能显示乱码。"; cat "$p"
}
main(){
  printf '%s\n' 'HM-RTK Jetson GPIO UART 工具' '' 'Jetson Nano 常见 GPIO UART 为 /dev/ttyTHS1；其他型号和载板必须核对 pinout。'
  local c; while true; do printf '\n1. 配置 GPIO 串口\n2. 选择串口路径\n3. 读取串口数据（115200 8N1）\nq. 退出\n'; read -r -p '请选择： ' c
    case "$c" in 1) configure;; 2) choose_port;; 3) read_data;; q|Q) return 0;; *) echo '无效选项。';; esac
  done
}
main "$@"
