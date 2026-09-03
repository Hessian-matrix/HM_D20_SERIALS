#!/usr/bin/env bash
# Hessian Matrix RTK: Raspberry Pi GPIO UART setup and serial test tool
set -u
STATE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hm-rtk"; PORT_FILE="$STATE_DIR/serial_port"
say(){ printf '\n%s\n' "$*"; }; die(){ printf '\nError: %s\n' "$*" >&2; exit 1; }; ask(){ local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]; }; user_name(){ [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]] && printf '%s' "$SUDO_USER" || printf '%s' "$USER"; }
cfg_path(){ [[ -f /boot/firmware/config.txt ]] && printf /boot/firmware/config.txt || [[ -f /boot/config.txt ]] && printf /boot/config.txt || true; }; cmd_path(){ [[ -f /boot/firmware/cmdline.txt ]] && printf /boot/firmware/cmdline.txt || [[ -f /boot/cmdline.txt ]] && printf /boot/cmdline.txt || true; }; backup(){ local f="$1"; [[ -f "$f" ]] && sudo cp -a -- "$f" "$f.hm-rtk.bak.$(date +%Y%m%d-%H%M%S)"; }
ports(){ PORTS=(); local p; for p in /dev/serial0 /dev/serial1 /dev/ttyUSB* /dev/ttyACM* /dev/ttyAMA* /dev/ttyS*; do [[ -e "$p" ]] || continue; PORTS+=("$p"); done; }
choose_port(){
  ports; ((${#PORTS[@]})) || die 'No serial port found.'
  say 'Scanning serial ports; each port is monitored for up to 2 seconds for a GGA sentence.'
  local matches=() p
  for p in "${PORTS[@]}"; do
    printf 'Checking %s ... ' "$p"
    if probe_port "$p"; then matches+=("$p"); printf 'GGA detected\n'; else printf 'no GGA detected\n'; fi
  done
  if ((${#matches[@]} == 1)); then save_port "${matches[0]}"; printf 'Automatically selected port: %s\n' "${matches[0]}"; return 0; fi
  if ((${#matches[@]} > 1)); then say 'Multiple ports are outputting GGA. Select the port connected to the device:'; select_port_from "${matches[@]}"; else say 'No GGA sentence was detected automatically. Select from all candidates:'; select_port_from "${PORTS[@]}"; fi
}
save_port(){ mkdir -p -- "$STATE_DIR"; printf '%s\n' "$1" >"$PORT_FILE"; }
select_port_from(){ local candidates=("$@") i n; for i in "${!candidates[@]}"; do printf '%d) %s\n' "$((i+1))" "${candidates[$i]}"; done; read -r -p 'Select a port (default 1): ' n; [[ "$n" =~ ^[0-9]+$ ]] || n=1; ((n>=1 && n<=${#candidates[@]})) || die 'Invalid number.'; save_port "${candidates[$((n-1))]}"; printf 'Saved port: %s\n' "${candidates[$((n-1))]}"; }
probe_port(){ local p="$1" saved sample result=1; [[ -e "$p" ]] || return 1; saved="$(stty -g -F "$p" 2>/dev/null || true)"; [[ -n "$saved" ]] || return 1; stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts 2>/dev/null || return 1; sample="$(mktemp "${TMPDIR:-/tmp}/hm-rtk-gga.XXXXXX")" || { stty -F "$p" "$saved" 2>/dev/null || true; return 1; }; timeout 2s cat "$p" >"$sample" 2>/dev/null || true; grep -a -q -E '\$[[:alnum:]]{2}GGA,' "$sample" && result=0; rm -f -- "$sample"; stty -F "$p" "$saved" 2>/dev/null || true; return "$result"; }
configure(){ local cfg cmd u; cfg="$(cfg_path)"; cmd="$(cmd_path)"; [[ -n "$cfg" && -n "$cmd" ]] || die 'config.txt or cmdline.txt was not found.'; u="$(user_name)"; sudo -v || die 'sudo validation failed.'; say 'This will enable UART as needed, remove the serial console, disable serial-getty, and add the user to dialout. Configuration files are backed up before changes.'; ask 'Proceed?' || return; backup "$cfg"; backup "$cmd"; if sudo grep -qE '^enable_uart=' "$cfg"; then sudo sed -i -E 's/^enable_uart=.*/enable_uart=1/' "$cfg"; else printf '\nenable_uart=1\n' | sudo tee -a "$cfg" >/dev/null; fi; sudo sed -i -E 's/(^| )console=(serial0|serial[0-9]+|ttyAMA[0-9]+|ttyS[0-9]+),[0-9]+n?[0-9]*//g; s/  +/ /g; s/^ //; s/ $//' "$cmd"; sudo systemctl disable --now serial-getty@serial0.service 2>/dev/null || true; sudo usermod -aG dialout "$u"; say 'Configuration complete.'; echo "User $u was added to dialout; reboot is required for the boot configuration to take effect."; ask 'Reboot now?' && sudo reboot || echo 'Run later: sudo reboot'; }
read_data(){ local p saved; p="${1:-}"; [[ -n "$p" ]] || { [[ -s "$PORT_FILE" ]] && p="$(head -n1 "$PORT_FILE")" || p=/dev/serial0; }; [[ -e "$p" ]] || die "Serial port does not exist: $p"; saved="$(stty -g -F "$p" 2>/dev/null || true)"; [[ -n "$saved" ]] || die 'Cannot open the port; check permissions and conflicts.'; stty -F "$p" 115200 cs8 -cstopb -parenb raw -echo -ixon -ixoff -crtscts || die 'Cannot configure the port.'; trap 'stty -F "$p" "$saved" 2>/dev/null || true; printf "\nSerial settings restored.\n"' EXIT INT TERM; say "Reading $p; press Ctrl+C to exit. NMEA is readable; binary UBX may look garbled."; cat "$p"; }
main(){ printf '%s\n' 'Hessian Matrix RTK Raspberry Pi GPIO UART tool' '' 'This tool enables GPIO UART, releases system conflicts, and reads raw D20/D13 data.'; local c; while true; do printf '\n1. Configure GPIO UART\n2. Automatically detect and select port (GGA)\n3. Read serial data (115200 8N1)\nq. Quit\n'; read -r -p 'Select: ' c; case "$c" in 1) configure;; 2) choose_port;; 3) read_data;; q|Q) return 0;; *) echo 'Invalid option.';; esac; done; }
main "$@"
