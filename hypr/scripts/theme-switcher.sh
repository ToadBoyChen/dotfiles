#!/bin/bash

SCRIPTS_DIR="$HOME/.config/hypr/scripts"
THEME_DIR="$HOME/.config/themes"
APPLY_SCRIPT="$SCRIPTS_DIR/apply-theme.sh"
CURRENT_THEME_FILE="$THEME_DIR/current_theme"
WAYBAR_CTL_SCRIPT="$SCRIPTS_DIR/waybar-ctl.sh"

THEME_LIST=$(find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
chosen_theme=$(printf "%s" "$THEME_LIST" | wofi --dmenu --prompt "Select Theme")

if [ -z "$chosen_theme" ]; then
    exit 0
fi

# 1. Apply the theme (generates files)
"$APPLY_SCRIPT" "$chosen_theme"

# 2. Reload services (delegates to controller for Waybar)
hyprctl reload
"$WAYBAR_CTL_SCRIPT" reload-style

# Dunst restart logic...
if systemctl --user is-active --quiet dunst.service; then
    systemctl --user restart dunst.service
else
    killall -q dunst
    while pgrep -u $UID -x dunst >/dev/null; do sleep 0.1; done
    dunst &
fi

echo "$chosen_theme" > "$CURRENT_THEME_FILE"
notify-send "Theme Changed" "Applied '$chosen_theme'"