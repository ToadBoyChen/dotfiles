#!/bin/bash

# A script to APPLY a theme to all configured applications.
# It takes one argument: the name of the theme directory.
# Usage: apply-theme.sh <theme_name>

# Stop the script if any command fails
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

# --- Apply theme to each application ---

# 1. Hyprland
echo "Theming Hyprland..."
HYPR_THEME_FILE="$HOME/.config/hypr/theme.conf"
sed "$sed_command" "$TEMPLATE_DIR/hyprland.template" > "$HYPR_THEME_FILE"
sed -i 's/rgb(#/rgb(/g' "$HYPR_THEME_FILE"

# 2. Wofi
echo "Theming Wofi..."
sed "$sed_command" "$TEMPLATE_DIR/wofi.template" > "$HOME/.config/wofi/style.css"

# 3. Dunst
echo "Theming Dunst..."
sed "$sed_command" "$TEMPLATE_DIR/dunst.template" > "$HOME/.config/dunst/dunstrc"

# 4. Waybar
echo "Theming Waybar..."
WAYBAR_TEMPLATE_SYMLINK="$TEMPLATE_DIR/waybar.template" # Use the symlink!
WAYBAR_STYLE_FILE="$HOME/.config/waybar/style.css"
# Write to a temporary file first to avoid a race condition
sed "$sed_command" "$WAYBAR_TEMPLATE_SYMLINK" > "${WAYBAR_STYLE_FILE}.tmp"
# Then, atomically move the new file into place.
mv "${WAYBAR_STYLE_FILE}.tmp" "$WAYBAR_STYLE_FILE"