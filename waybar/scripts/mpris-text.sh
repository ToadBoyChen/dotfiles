#!/bin/bash

# --- NEW FUNCTION: Truncates text if it exceeds a limit ---
# Used for the horizontal layout.
truncate_text() {
    local text="$1"
    local limit="$2"
    if (( ${#text} > limit )); then
        # Truncate and add ellipsis
        echo "${text:0:$((limit - 3))}..."
    else
        # Return text as is
        echo "$text"
    fi
}

# --- NEW FUNCTION: Wraps text at the last possible space before the limit ---
# This function will only ever create a single wrap (two lines max).
# Used for the vertical layout.
wrap_text_once() {
    local input_text="$1"
    local line_limit="$2"
    
    # If the text is already short enough, just return it.
    if (( ${#input_text} <= line_limit )); then
        echo "$input_text"
        return
    fi

    local first_line=""
    local rest_of_text=""

    # Find the last space before the character limit
    # We create a substring up to the limit and find the last space in that.
    local break_point
    break_point=$(echo "${input_text:0:line_limit}" | grep -o '.* ' | tail -n 1 | wc -c)

    # If a space was found (break_point > 0), split the string there.
    # We subtract 1 because wc -c includes the trailing space itself.
    if (( break_point > 0 )); then
        local split_at=$((break_point - 1))
        first_line="${input_text:0:split_at}"
        rest_of_text="${input_text:split_at+1}"
        echo "$first_line"$'\n'"$rest_of_text"
    else
        # If no space was found (e.g., a very long single word),
        # we just truncate the word to avoid a messy overflow.
        echo "${input_text:0:$((line_limit-3))}..."
    fi
}

# --- Main Script ---
PLAYER="spotify"
CONFIG_SYMLINK="$HOME/.config/waybar/config"
PLAYER_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null || echo "Stopped")

# --- MODIFIED SECTION START ---
if [[ "$PLAYER_STATUS" == "Stopped" ]]; then
    # Display custom text when no music is playing.
    # The single quote in "chen's" is handled correctly by using double quotes for the text string.
    printf '%s' "Toby Chen's t480" | jq -Rsc '{"text": ., "class": "custom"}'
    exit 0
fi
# --- MODIFIED SECTION END ---

# Get metadata and escape it for Pango/JSON
ARTIST_FULL=$(playerctl --player=$PLAYER metadata artist | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')
TITLE_FULL=$(playerctl --player=$PLAYER metadata title | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')

# --- Determine Layout and Process Text ---
PROCESSED_TITLE=""
PROCESSED_ARTIST=""

if readlink "$CONFIG_SYMLINK" | grep -q "vertical"; then
    # --- VERTICAL LAYOUT ---
    CHAR_LIMIT_V=30 # You can adjust this limit
    PROCESSED_TITLE=$(wrap_text_once "$TITLE_FULL" "$CHAR_LIMIT_V")
    PROCESSED_ARTIST=$(wrap_text_once "$ARTIST_FULL" "$CHAR_LIMIT_V")
else
    # --- HORIZONTAL LAYOUT ---
    CHAR_LIMIT_H=30 # You can adjust this limit
    PROCESSED_TITLE=$(truncate_text "$TITLE_FULL" "$CHAR_LIMIT_H")
    PROCESSED_ARTIST=$(truncate_text "$ARTIST_FULL" "$CHAR_LIMIT_H")
fi

# --- Combine and Format Output ---
# This part is now the same for both layouts.
OUTPUT_TEXT=$(printf "<b>%s</b>\n%s" "$PROCESSED_TITLE" "$PROCESSED_ARTIST")

# Pipe the multi-line text into jq to preserve newlines and create valid JSON
# Using -Rs ("raw slurp") is the most robust way to do this.
printf '%s' "$OUTPUT_TEXT" | jq -Rsc '{"text": ., "class": "active"}'