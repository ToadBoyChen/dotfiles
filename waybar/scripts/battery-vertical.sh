#!/bin/bash

# Get battery info from upower
bat0_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
bat1_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)

# --- Battery 0 (Internal) ---
bat0_perc=$(echo "$bat0_info" | grep "percentage" | awk '{print $2}' | sed 's/%//')
bat0_state=$(echo "$bat0_info" | grep "state" | awk '{print $2}')

# Determine icon for BAT0
if [[ "$bat0_state" == "charging" ]]; then
    icon0="󰂄"
elif [[ "$bat0_perc" -le 15 ]]; then
    icon0=""
elif [[ "$bat0_perc" -le 30 ]]; then
    icon0=""
elif [[ "$bat0_perc" -le 50 ]]; then
    icon0=""
elif [[ "$bat0_perc" -le 80 ]]; then
    icon0=""
else
    icon0=""
fi

# --- Battery 1 (External) ---
bat1_perc=$(echo "$bat1_info" | grep "percentage" | awk '{print $2}' | sed 's/%//')
bat1_state=$(echo "$bat1_info" | grep "state" | awk '{print $2}')

# Determine icon for BAT1
if [[ "$bat1_state" == "charging" ]]; then
    icon1="󰂄"
elif [[ "$bat1_perc" -le 15 ]]; then
    icon1=""
elif [[ "$bat1_perc" -le 30 ]]; then
    icon1=""
elif [[ "$bat1_perc" -le 50 ]]; then
    icon1=""
elif [[ "$bat1_perc" -le 80 ]]; then
    icon1=""
else
    icon1=""
fi

# --- Overall Status for CSS Class ---
# The module's background color will be based on the most urgent status
if [[ "$bat0_state" == "charging" || "$bat1_state" == "charging" ]]; then
    class="charging"
elif [[ "$bat0_perc" -le 15 || "$bat1_perc" -le 15 ]]; then
    class="critical"
elif [[ "$bat0_perc" -le 30 || "$bat1_perc" -le 30 ]]; then
    class="warning"
else
    class="good"
fi

# Format the output strings with a newline character between them
line1="$icon0"
line2="$icon1"
text="$line1\n$line2"

# Tooltip remains the same
tooltip="Internal: $bat0_perc% ($bat0_state)\nExternal: $bat1_perc% ($bat1_state)"

# Output JSON for Waybar
printf '{"text":"%s", "tooltip":"%s", "class":"%s"}\n' "$text" "$tooltip" "$class"