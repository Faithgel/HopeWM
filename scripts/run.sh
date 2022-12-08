#!/bin/sh

xrdb merge ~/.Xresources 

feh --bg-fill ~/Descargas/968378.png &

~/.config/scripts/bar.sh &
while type dwm >/dev/null; do dwm && continue || break; done
