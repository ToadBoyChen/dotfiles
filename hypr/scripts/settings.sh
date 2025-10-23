#!/bin/bash

set -x

WALLPAPER_DIR="$HOME/.config/wallpapers/"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
THEME_SWITCHER="$SCRIPTS_DIR/theme-switcher.sh"
WAYBAR_CTL_SCRIPT="$SCRIPTS_DIR/waybar-ctl.sh"

# --- Main Menu ---
choice=$(printf "  Random Wallpaper\n󰸉  Select Wallpaper\n🎨 Change Theme\n Choose Waybar Type\n  Reload Waybar\n  Volume Settings\n  Nwg Settings" | \
  wofi --dmenu --prompt "Settings")

case "$choice" in
  "  Random Wallpaper")
    RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" | shuf -n 1)
    if [[ -n "$RANDOM_WALLPAPER" ]]; then
      swww img "$RANDOM_WALLPAPER" --transition-type any --transition-fps 60
      notify-send "Wallpaper Changed" "Set to $(basename "$RANDOM_WALLPAPER")"
    else
      notify-send "Wallpaper Error" "No wallpapers found in $WALLPAPER_DIR"
    fi
    ;;
  "󰸉  Select Wallpaper")
    SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
      | sort \
      | wofi --dmenu --prompt "Select Wallpaper")

    if [[ -n "$SELECTED_WALLPAPER" ]]; then
      swww img "$SELECTED_WALLPAPER" --transition-type any --transition-fps 60
      notify-send "Wallpaper Changed" "Set to $(basename "$SELECTED_WALLPAPER")"
    else
      notify-send "Wallpaper" "No wallpaper selected"
    fi
    ;;
  "🎨  Change Theme")
    "$THEME_SWITCHER"
    ;;
  " Choose Waybar Type")
    "$WAYBAR_CTL_SCRIPT" choose
    ;;
  "  Reload Waybar")
    "$WAYBAR_CTL_SCRIPT" restart
    ;;
  "  Volume Settings")
    pavucontrol &
    ;;
  "  Nwg Settings")
    nwg-look &
    ;;
esac

