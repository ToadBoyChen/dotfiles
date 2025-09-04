#!/bin/bash

# Check if dunst is paused
if [ "$(dunstctl is-paused)" = "true" ]; then
    # If paused, show the 'Do Not Disturb' icon and tooltip
    echo '{"text": "", "tooltip": "Notifications Paused (Do Not Disturb)"}'
else
    # If not paused, show the standard notification icon
    echo '{"text": "", "tooltip": "Notifications Active"}'
fi