#!/usr/bin/env bash
# Hessian Matrix RTK: Jetson GPIO UART setup and serial test tool
set -u
STATE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hm-rtk"; PORT_FILE="$STATE_DIR/serial_port"; RULE_FILE=/etc/udev/rules.d/99-hm-rtk-uart.rules
say(){ printf '\n%s\n' "$*"; }; die(){ printf '\nError: %s\n' "$*" >&2; exit 1; }; ask(){ local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]; }; user_name(){ [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]] && printf '%s' "$SUDO_USER" || printf '%s' "$USER"; }
ports(){ PORTS=(); local p; for p in /dev/ttyTHS* /dev/ttyUSB* /dev/ttyACM*; do [[ -e "$p" ]] || continue; case " ${PORTS[*]} " in *" $p "*) ;; *) PORTS+=("$p");; esac; done; }
choose_port(){
  ports; ((${#PORTS[@]})) || die 'No ttyTHS/USB/ACM serial port found.'
  say 'Scanning serial ports; each port is monitored for up to 2 seconds for a GGA sentence.'
  local matches=() p
  for p in "${PORTS[@]}"; do
    printf 'Checking %s ... ' "$p"
    if probe_port "$p"; then
      matches+=("$p"); printf 'GGA detected\n'
    else
      printf 'no GGA detected\n'
    fi
  done
  if ((${#matches[@]} == 1)); then
    save_port "${matches[0]}"; printf 'Automatically selected port: %s\n' "${matches[0]}"; return 0
  fi
  if ((${#matches[@]} > 1)); then
    say 'Multiple ports are outputting GGA. Select the port connected to the device:'
    select_port_from "${matches[@]}"
  else
    say 'No GGA sentence was detected automatically. Select from all candidates:'
    select_port_from "${PORTS[@]}"
  fi
}
save_port(){
  mkdir -p -- "$STATE_DIR"; printf '%s\n' "$1" >"$PORT_FILE"
}
select_port_from(){
  local candidates=("$@") i n
  for i in "${!candidates[@]}"; do printf '%d) %s\n' "$((i+1))" "${candidates[$i]}"; done
  read -r -p 'Select a port (default 1): ' n; [[ "$n" =~ ^[0-9]+$ ]] || n=1
  ((n>=1 && n<=${#candidates[@]})) || die 'Invalid number.'
  save_port "${candidates[$((n-1))]}"
  printf 'Saved port: %s\n' "${candidates[$((n-1))]}"
}
probe_port(){
  local p="$1" saved sample result=1
  [[ -e "$p" ]] || return 1
  saved="$(stty -g -F "$p" 2>/dev/null || true)"
  [[ -n "$saved" ]] || return 1
  stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts 2>/dev/null || return 1
  sample="$(mktemp "${TMPDIR:-/tmp}/hm-rtk-gga.XXXXXX")" || { stty -F "$p" "$saved" 2>/dev/null || true; return 1; }
  timeout 2s cat "$p" >"$sample" 2>/dev/null || true
  grep -a -q -E '\$[[:alnum:]]{2}GGA,' "$sample" && result=0
  rm -f -- "$sample"
  stty -F "$p" "$saved" 2>/dev/null || true
  return "$result"
}
gpio_port(){ [[ -e /dev/ttyTHS1 ]] && { printf /dev/ttyTHS1; return; }; local a=() p; for p in /dev/ttyTHS*; do [[ -e "$p" ]] && a+=("$p"); done; ((${#a[@]}==1)) && printf '%s' "${a[0]}"; }
configure(){ local p u base; p="$(gpio_port)"; u="$(user_name)"; sudo -v || die 'sudo validation failed.'; say 'This will disable nvgetty/getty, add the user to dialout, and persist GPIO-UART permissions. It does not install ROS or modify the device tree.'; ask 'Proceed?' || return; sudo systemctl disable --now nvgetty 2>/dev/null || true; sudo usermod -aG dialout "$u"; if [[ -n "$p" ]]; then base="$(basename "$p")"; sudo systemctl disable --now "serial-getty@${base}.service" 2>/dev/null || true; printf 'KERNEL=="%s", GROUP="dialout", MODE="0660"\n' "$base" | sudo tee "$RULE_FILE" >/dev/null; sudo udevadm control --reload-rules 2>/dev/null || true; sudo udevadm trigger --name-match="$base" 2>/dev/null || true; mkdir -p -- "$STATE_DIR"; printf '%s\n' "$p" >"$PORT_FILE"; printf 'GPIO UART: %s\n' "$p"; else echo 'Could not determine the GPIO UART automatically; use option 2 to select it.'; fi; echo "User $u was added to dialout; log in again before reading the port."; }
read_data(){ local p saved; p="${1:-}"; [[ -n "$p" ]] || { [[ -s "$PORT_FILE" ]] && p="$(head -n1 "$PORT_FILE")" || p=/dev/ttyTHS1; }; [[ -e "$p" ]] || die "Serial port does not exist: $p"; saved="$(stty -g -F "$p" 2>/dev/null || true)"; [[ -n "$saved" ]] || die 'Cannot open the port; check permissions and conflicts.'; stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts || die 'Cannot configure the port.'; trap 'stty -F "$p" "$saved" 2>/dev/null || true; printf "\nSerial settings restored.\n"' EXIT INT TERM; say "Reading $p; press Ctrl+C to exit. NMEA is readable; binary UBX may look garbled."; cat "$p"; }
main(){ printf '%s\n' 'Hessian Matrix RTK Jetson GPIO UART tool' '' 'Jetson Nano commonly uses /dev/ttyTHS1; verify the pinout for every other model and carrier board.'; local c; while true; do printf '\n1. Configure GPIO UART\n2. Automatically detect and select port (GGA)\n3. Read serial data (115200 8N1)\nq. Quit\n'; read -r -p 'Select: ' c; case "$c" in 1) configure;; 2) choose_port;; 3) read_data;; q|Q) return 0;; *) echo 'Invalid option.';; esac; done; }
main "$@"
