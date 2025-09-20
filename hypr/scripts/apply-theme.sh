#!/bin/bash

set -e

# --- Configuration ---
THEME_DIR="$HOME/.config/themes"
TEMPLATE_DIR="$HOME/.config/templates"

# --- Argument Check ---
if [ -z "$1" ]; then
    echo "Error: No theme name provided."
    echo "Usage: $0 <theme_name>"
    exit 1
fi

THEME_NAME="$1"
VAR_FILE="$THEME_DIR/$THEME_NAME/theme.vars"

if [ ! -f "$VAR_FILE" ]; then
    echo "Error: Theme '$THEME_NAME' not found at $VAR_FILE"
    exit 1
fi

echo "Applying theme: $THEME_NAME"

# --- Variable Handling ---
source "$VAR_FILE"
sed_command=""
while IFS='=' read -r key value; do
    [[ "$key" =~ ^# || -z "$key" ]] && continue
    final_value="${!key}"
    safe_value=$(printf '%s\n' "$final_value" | sed -e 's/[\/&]/\\&/g')
    placeholder="__$(echo "$key" | tr '[:lower:]' '[:upper:]')__"
    sed_command+="s/$placeholder/$safe_value/g;"
done < <(grep -v '^#' "$VAR_FILE" | sed 's/;/\n/g')

# =============================================================================
#  Generate derived variables for specific applications
# =============================================================================

hex_to_rgba() {
    local hex_color=$(echo "$1" | sed 's/#//')
    local opacity_hex="$2"
    echo "${hex_color}${opacity_hex}"
}

# --- UPGRADED SECTION ---
# Now handles all the colors needed for the new hyprlock template
if [[ -n "$text" && -n "$base" && -n "$mantle" && -n "$subtext0" && -n "$green" && -n "$red" && -n "$peach" ]]; then
    # Base colors
    HYPRLOCK_TEXT_RGBA_FF=$(hex_to_rgba "$text" "ff")
    HYPRLOCK_BASE_RGBA_CC=$(hex_to_rgba "$base" "cc")
    HYPRLOCK_MANTLE_RGBA_80=$(hex_to_rgba "$mantle" "80")
    HYPRLOCK_SUBTEXT0_RGBA_FF=$(hex_to_rgba "$subtext0" "ff")

    # State colors
    HYPRLOCK_GREEN_RGBA_FF=$(hex_to_rgba "$green" "ff")
    HYPRLOCK_RED_RGBA_FF=$(hex_to_rgba "$red" "ff")
    HYPRLOCK_WARN_RGBA_FF=$(hex_to_rgba "$peach" "ff") # Using peach for warnings
    
    # Simple hex for pango markup
    HYPRLOCK_WARN_HEX=$(echo "$peach" | sed 's/#//')

    # Add all generated variables to the main sed command
    sed_command+="s/__TEXT_RGBA_FF__/$HYPRLOCK_TEXT_RGBA_FF/g;"
    sed_command+="s/__BASE_RGBA_CC__/$HYPRLOCK_BASE_RGBA_CC/g;"
    sed_command+="s/__MANTLE_RGBA_80__/$HYPRLOCK_MANTLE_RGBA_80/g;"
    sed_command+="s/__SUBTEXT0_RGBA_FF__/$HYPRLOCK_SUBTEXT0_RGBA_FF/g;"
    sed_command+="s/__GREEN_RGBA_FF__/$HYPRLOCK_GREEN_RGBA_FF/g;"
    sed_command+="s/__RED_RGBA_FF__/$HYPRLOCK_RED_RGBA_FF/g;"
    sed_command+="s/__WARN_RGBA_FF__/$HYPRLOCK_WARN_RGBA_FF/g;"
    sed_command+="s/__WARN_HEX__/$HYPRLOCK_WARN_HEX/g;"
fi


echo "Theming Hyprland..."
sed "$sed_command" "$TEMPLATE_DIR/hyprland.template" > "$HOME/.config/hypr/theme.conf"
sed -i 's/rgb(#/rgb(/g' "$HOME/.config/hypr/theme.conf"

echo "Theming Wofi..."
sed "$sed_command" "$TEMPLATE_DIR/wofi.template" > "$HOME/.config/wofi/style.css"

echo "Theming Dunst..."
sed "$sed_command" "$TEMPLATE_DIR/dunst.template" > "$HOME/.config/dunst/dunstrc"

echo "Theming Waybar..."
sed "$sed_command" "$TEMPLATE_DIR/waybar.template" > "$HOME/.config/waybar/style.css.tmp" && mv "$HOME/.config/waybar/style.css.tmp" "$HOME/.config/waybar/style.css"

echo "Theming Hyprlock..."
sed "$sed_command" "$TEMPLATE_DIR/hyprlock.template" > "$HOME/.config/hypr/hyprlock.conf"

echo "Theme applied successfully!"