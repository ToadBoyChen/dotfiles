#!/bin/bash

if [ "$(dunstctl is-paused)" = "true" ]; then
    echo '{"text": "", "tooltip": "Notifications Paused (Do Not Disturb)"}'
else
    echo '{"text": "", "tooltip": "Notifications Active"}'
fi
