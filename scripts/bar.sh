#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/scripts/bar_themes/catppuccin

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  updates=$(doas xbps-install -un | wc -l) # void
  updates=$(checkupdates | wc -l)   # arch
  updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/*/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  printf "^c$blue^   "
  printf "^c$blue^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

sound() {
  printf "^c$darkblue^  "
  printf "^c$darkblue^%.0f\n" $(amixer get Master | grep -o "[0-9]*%" | head -n 1 | sed 's/%//')
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$blue^ 󱑆 "
	printf "^c$black^^b$darkblue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ]
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "  $(battery) $(brightness) $(sound) $(cpu) $(mem) $(wlan) $(clock)"
done
