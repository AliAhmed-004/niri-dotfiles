#!/usr/bin/env bash

OPTIONS="⏾    Suspend\n⏻    Power Off\n↻    Reboot\n⇠    Logout"

CHOICE=$(printf "$OPTIONS" | rofi -dmenu -i -p "Power")

case "$CHOICE" in
"⏾    Suspend")
  swaylock -f &
  sleep 0.5
  systemctl suspend
  ;;
"⏻    Power Off")
  systemctl poweroff
  ;;
"↻    Reboot")
  systemctl reboot
  ;;
"⇠    Logout")
  niri msg action quit
  ;;
esac
