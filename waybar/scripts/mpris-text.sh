#!/bin/bash

truncate_text() {
    local text="$1"
    local limit="$2"
    if (( ${#text} > limit )); then
        echo "${text:0:$((limit - 3))}..."
    else
        echo "$text"
    fi
}

wrap_text_once() {
    local input_text="$1"
    local line_limit="$2"
    
    if (( ${#input_text} <= line_limit )); then
        echo "$input_text"
        return
    fi

    local first_line=""
    local rest_of_text=""

    local break_point
    break_point=$(echo "${input_text:0:line_limit}" | grep -o '.* ' | tail -n 1 | wc -c)

    if (( break_point > 0 )); then
        local split_at=$((break_point - 1))
        first_line="${input_text:0:split_at}"
        rest_of_text="${input_text:split_at+1}"
        echo "$first_line"$'\n'"$rest_of_text"
    else
        echo "${input_text:0:$((line_limit-3))}..."
    fi
}

PLAYER="spotify"
CONFIG_SYMLINK="$HOME/.config/waybar/config"
PLAYER_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null || echo "Stopped")

if [[ "$PLAYER_STATUS" == "Stopped" ]]; then
    printf '%s' "Toby Chen's T480" | jq -Rsc '{"text": ., "class": "custom"}'
    exit 0
fi

ARTIST_FULL=$(playerctl --player=$PLAYER metadata artist | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')
TITLE_FULL=$(playerctl --player=$PLAYER metadata title | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')

PROCESSED_TITLE=""
PROCESSED_ARTIST=""

if readlink "$CONFIG_SYMLINK" | grep -q "vertical"; then
    CHAR_LIMIT_V=30
    PROCESSED_TITLE=$(wrap_text_once "$TITLE_FULL" "$CHAR_LIMIT_V")
    PROCESSED_ARTIST=$(wrap_text_once "$ARTIST_FULL" "$CHAR_LIMIT_V")
    OUTPUT_TEXT=$(printf "<b>%s</b>\n%s" "$PROCESSED_TITLE" "$PROCESSED_ARTIST")

else
    CHAR_LIMIT_H=30i 
    PROCESSED_TITLE=$(truncate_text "$TITLE_FULL" "$CHAR_LIMIT_H")
    PROCESSED_ARTIST=$(truncate_text "$ARTIST_FULL" "$CHAR_LIMIT_H")
    OUTPUT_TEXT=$(printf "<b>%s: </b>%s" "$PROCESSED_ARTIST" "$PROCESSED_TITLE")
fi

printf '%s' "$OUTPUT_TEXT" | jq -Rsc '{"text": ., "class": "active"}'
