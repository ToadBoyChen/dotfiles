#!/bin/bash

# --- SCRIPT ---
PLAYER="spotify"
PLAYER_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null || echo "Stopped")
ART_PATH="$HOME/.cache/waybar-mpris-art"
ART_PATH_URL_CACHE="${ART_PATH}.url"

if [[ "$PLAYER_STATUS" = "Stopped" ]]; then
    echo '{}'
    exit 0
fi

IMAGE_TAG=""
ART_URL=$(playerctl --player=$PLAYER metadata mpris:artUrl 2>/dev/null || echo "")

if [[ "$(cat "$ART_PATH_URL_CACHE" 2>/dev/null)" != "$ART_URL" ]]; then
    curl -s -o "$ART_PATH" "$ART_URL"
    echo "$ART_URL" > "$ART_PATH_URL_CACHE"
    ~/.config/hypr/scripts/waybar-ctl.sh reload-style --silent
fi

IMAGE_TAG="<img src=\"${ART_PATH}?t=$(date +%s)></img>"

jq -n --arg text "$IMAGE_TAG" '{"text": $text, "class": "active"}'