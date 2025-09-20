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
# Read all variables from theme.vars and prepare them for sed
while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^# || -z "$key" ]] && continue
    # Get the final value of the variable (resolves variables like accent=$lavender)
    final_value="${!key}"
    # Escape special characters for sed
    safe_value=$(printf '%s\n' "$final_value" | sed -e 's/[\/&]/\\&/g')
    # Create an __UPPERCASE__ placeholder
    placeholder="__$(echo "$key" | tr '[:lower:]' '[:upper:]')__"
    sed_command+="s/$placeholder/$safe_value/g;"
done < <(grep -v '^#' "$VAR_FILE" | sed 's/;/\n/g')



# =============================================================================
#  Generate Derived Variables for Hyprlock
# =============================================================================

# THIS FUNCTION IS THE ONLY CHANGE. It now wraps the output in rgba().
hex_to_hyprlock_rgba() {
    local hex_color=$(echo "$1" | sed 's/#//')
    local opacity_hex="$2"
    echo "rgba(${hex_color}${opacity_hex})" # <-- Corrected line
}

if [[ -n "$text" && -n "$base" && -n "$mantle" && -n "$subtext0" && -n "$green" && -n "$red" && -n "$peach" && -n "$accent" ]]; then
    echo "Generating derived variables for Hyprlock..."
    
    HYPRLOCK_TEXT=$(hex_to_hyprlock_rgba "$text" "ff")
    HYPRLOCK_SUBTEXT=$(hex_to_hyprlock_rgba "$subtext0" "ff")
    HYPRLOCK_INPUT_INNER=$(hex_to_hyprlock_rgba "$base" "cc")
    HYPRLOCK_INPUT_OUTER=$(hex_to_hyprlock_rgba "$mantle" "80")
    HYPRLOCK_ACCENT_BORDER=$(hex_to_hyprlock_rgba "$accent" "cc")
    HYPRLOCK_CHECK=$(hex_to_hyprlock_rgba "$green" "ff")
    HYPRLOCK_FAIL=$(hex_to_hyprlock_rgba "$red" "ff")
    HYPRLOCK_WARN=$(hex_to_hyprlock_rgba "$peach" "ff")
    HYPRLOCK_WARN_HEX=$(echo "$peach" | sed 's/#//')

    sed_command+="s/__HYPRLOCK_TEXT__/$HYPRLOCK_TEXT/g;"
    sed_command+="s/__HYPRLOCK_SUBTEXT__/$HYPRLOCK_SUBTEXT/g;"
    sed_command+="s/__HYPRLOCK_INPUT_INNER__/$HYPRLOCK_INPUT_INNER/g;"
    sed_command+="s/__HYPRLOCK_INPUT_OUTER__/$HYPRLOCK_INPUT_OUTER/g;"
    sed_command+="s/__HYPRLOCK_ACCENT_BORDER__/$HYPRLOCK_ACCENT_BORDER/g;"
    sed_command+="s/__HYPRLOCK_CHECK__/$HYPRLOCK_CHECK/g;"
    sed_command+="s/__HYPRLOCK_FAIL__/$HYPRLOCK_FAIL/g;"
    sed_command+="s/__HYPRLOCK_WARN__/$HYPRLOCK_WARN/g;"
    sed_command+="s/__HYPRLOCK_WARN_HEX__/$HYPRLOCK_WARN_HEX/g;"
fi


# --- Apply Themes ---
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