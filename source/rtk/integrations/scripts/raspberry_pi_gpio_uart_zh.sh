#!/usr/bin/env bash
# 黑森矩阵 RTK：树莓派 GPIO UART 配置与串口检查工具
set -u
STATE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hm-rtk"; PORT_FILE="$STATE_DIR/serial_port"
say(){ printf '\n%s\n' "$*"; }; die(){ printf '\n错误：%s\n' "$*" >&2; exit 1; }; ask(){ local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]; }; user_name(){ [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]] && printf '%s' "$SUDO_USER" || printf '%s' "$USER"; }
cfg_path(){ [[ -f /boot/firmware/config.txt ]] && printf /boot/firmware/config.txt || [[ -f /boot/config.txt ]] && printf /boot/config.txt || true; }; cmd_path(){ [[ -f /boot/firmware/cmdline.txt ]] && printf /boot/firmware/cmdline.txt || [[ -f /boot/cmdline.txt ]] && printf /boot/cmdline.txt || true; }
backup(){ local f="$1"; [[ -f "$f" ]] && sudo cp -a -- "$f" "$f.hm-rtk.bak.$(date +%Y%m%d-%H%M%S)"; }
ports(){ PORTS=(); local p; for p in /dev/serial0 /dev/serial1 /dev/ttyUSB* /dev/ttyACM* /dev/ttyAMA* /dev/ttyS*; do [[ -e "$p" ]] || continue; PORTS+=("$p"); done; }
choose_port(){
  ports; ((${#PORTS[@]})) || die '没有发现串口设备。'
  say '正在自动检测串口；每个串口最多监听 2 秒，寻找 GGA 语句。'
  local matches=() p
  for p in "${PORTS[@]}"; do
    printf '检测 %s ... ' "$p"
    if probe_port "$p"; then matches+=("$p"); printf '检测到 GGA\n'; else printf '未检测到 GGA\n'; fi
  done
  if ((${#matches[@]} == 1)); then save_port "${matches[0]}"; printf '已自动选择端口：%s\n' "${matches[0]}"; return 0; fi
  if ((${#matches[@]} > 1)); then say '检测到多个输出 GGA 的串口，请选择设备对应的端口：'; select_port_from "${matches[@]}"; else say '未自动检测到 GGA，将显示所有候选串口供手动选择。'; select_port_from "${PORTS[@]}"; fi
}
save_port(){ mkdir -p -- "$STATE_DIR"; printf '%s\n' "$1" >"$PORT_FILE"; }
select_port_from(){ local candidates=("$@") i n; for i in "${!candidates[@]}"; do printf '%d) %s\n' "$((i+1))" "${candidates[$i]}"; done; read -r -p '请选择端口编号（默认 1）： ' n; [[ "$n" =~ ^[0-9]+$ ]] || n=1; ((n>=1 && n<=${#candidates[@]})) || die '编号无效。'; save_port "${candidates[$((n-1))]}"; printf '已保存端口：%s\n' "${candidates[$((n-1))]}"; }
probe_port(){ local p="$1" saved sample result=1; [[ -e "$p" ]] || return 1; saved="$(stty -g -F "$p" 2>/dev/null || true)"; [[ -n "$saved" ]] || return 1; stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts 2>/dev/null || return 1; sample="$(mktemp "${TMPDIR:-/tmp}/hm-rtk-gga.XXXXXX")" || { stty -F "$p" "$saved" 2>/dev/null || true; return 1; }; timeout 2s cat "$p" >"$sample" 2>/dev/null || true; grep -a -q -E '\$[[:alnum:]]{2}GGA,' "$sample" && result=0; rm -f -- "$sample"; stty -F "$p" "$saved" 2>/dev/null || true; return "$result"; }
configure(){ local cfg cmd u; cfg="$(cfg_path)"; cmd="$(cmd_path)"; [[ -n "$cfg" && -n "$cmd" ]] || die '找不到 config.txt 或 cmdline.txt。'; u="$(user_name)"; sudo -v || die 'sudo 验证失败。'; say '将按需启用 UART、删除串口 console、禁用 serial-getty 并加入 dialout。配置文件修改前会自动备份。'; ask '确认执行吗？' || return; backup "$cfg"; backup "$cmd"; if sudo grep -qE '^enable_uart=' "$cfg"; then sudo sed -i -E 's/^enable_uart=.*/enable_uart=1/' "$cfg"; else printf '\nenable_uart=1\n' | sudo tee -a "$cfg" >/dev/null; fi; sudo sed -i -E 's/(^| )console=(serial0|serial[0-9]+|ttyAMA[0-9]+|ttyS[0-9]+),[0-9]+n?[0-9]*//g; s/  +/ /g; s/^ //; s/ $//' "$cmd"; sudo systemctl disable --now serial-getty@serial0.service 2>/dev/null || true; sudo usermod -aG dialout "$u"; say '配置完成。'; echo "用户 $u 已加入 dialout；配置生效需要重启。"; ask '现在重启吗？' && sudo reboot || echo '稍后执行：sudo reboot'; }
read_data(){ local p saved; p="${1:-}"; [[ -n "$p" ]] || { [[ -s "$PORT_FILE" ]] && p="$(head -n1 "$PORT_FILE")" || p=/dev/serial0; }; [[ -e "$p" ]] || die "串口不存在：$p"; saved="$(stty -g -F "$p" 2>/dev/null || true)"; [[ -n "$saved" ]] || die '无法打开串口，请检查权限和占用。'; stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts || die '无法配置串口。'; trap 'stty -F "$p" "$saved" 2>/dev/null || true; printf "\n已恢复串口参数。\n"' EXIT INT TERM; say "正在读取 $p，按 Ctrl+C 退出。NMEA 可读，UBX 二进制可能显示乱码。"; cat "$p"; }
main(){ printf '%s\n' 'HM-RTK 树莓派 GPIO UART 工具' '' '本工具启用 GPIO UART、解除系统占用并读取 D20/D13 原始数据。'; local c; while true; do printf '\n1. 配置 GPIO 串口\n2. 自动识别并选择串口（检测 GGA）\n3. 读取串口数据（115200 8N1）\nq. 退出\n'; read -r -p '请选择： ' c; case "$c" in 1) configure;; 2) choose_port;; 3) read_data;; q|Q) return 0;; *) echo '无效选项。';; esac; done; }
main "$@"
