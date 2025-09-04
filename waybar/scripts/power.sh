#!/bin/bash

# Rofi Power Menu
# Icons:  Shutdown,  Reboot,  Suspend,  Lock,  Logout

options=" Shutdown\n Reboot\n Suspend\n Lock\n Logout"

chosen=$(echo -e "$options" | wofi -dmenu -i -p "Power" -theme-str 'window {width: 15%;} listview {lines: 5;}')

case "$chosen" in
    " Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Lock")
        # Use your preferred screen locker. swaylock is common.
        # If you use Hyprland, hyprlock is a good choice.
        # swaylock -f
        hyprlock
        ;;
    " Logout")
        # Adjust for your Wayland Compositor
        hyprctl dispatch exit "" # For Hyprland
        # swaymsg exit # For Sway
        ;;
esac