#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpapers/"
CONFIG_SYMLINK="$HOME/.config/waybar/config"
TEMPLATE_SYMLINK="$HOME/.config/templates/waybar.template"
CONFIG_V="$HOME/.config/waybar/config-vertical"
TEMPLATE_V="$HOME/.config/templates/waybar-vertical.template"
CONFIG_H="$HOME/.config/waybar/config-horizontal"
TEMPLATE_H="$HOME/.config/templates/waybar-horizontal.template"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
THEME_DIR="$HOME/.config/themes"
THEME_SWITCHER="$SCRIPTS_DIR/theme-switcher.sh"
APPLY_THEME_SCRIPT="$SCRIPTS_DIR/apply-theme.sh"
CURRENT_THEME_FILE="$THEME_DIR/current_theme"
WAYBAR_CTL_SCRIPT="$SCRIPTS_DIR/waybar-ctl.sh"

# --- Main Menu ---
choice=$(printf "  Random Wallpaper\n󰸉  Select Wallpaper\n🎨  Change Theme\n↔️  Toggle Bar Orientation\n  Reload Waybar\n  Volume Settings\n  Nwg Settings" | \
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
      | wofi --dmenu --prompt "🖼️ Select Wallpaper")

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
  "↔️  Toggle Bar Orientation")
    if [[ "$(readlink "$CONFIG_SYMLINK")" == *vertical* ]]; then
      notify-send "Waybar" "Switching to Horizontal Layout..."
      ln -sf "$CONFIG_H" "$CONFIG_SYMLINK"
      ln -sf "$TEMPLATE_H" "$TEMPLATE_SYMLINK"
    else
      notify-send "Waybar" "Switching to Vertical Layout..."
      ln -sf "$CONFIG_V" "$CONFIG_SYMLINK"
      ln -sf "$TEMPLATE_V" "$TEMPLATE_SYMLINK"
    fi
    current_theme="amethyst"
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        current_theme=$(cat "$CURRENT_THEME_FILE")
    fi
    "$APPLY_THEME_SCRIPT" "$current_theme"
    "$WAYBAR_CTL_SCRIPT" restart
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