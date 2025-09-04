#!/bin/bash

PLAYER="spotify"
STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)

if [ "$STATUS" = "Playing" ]; then
    echo '{"text": "󰐎"}' # Pause Icon
elif [ "$STATUS" = "Paused" ]; then
    echo '{"text": "󰐊"}' # Play Icon
else
    echo '{}' # Return empty to hide
fi