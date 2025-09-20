#!/bin/bash

status=$(cat /sys/class/power_supply/AC/online 2>/dev/null)

if [ "$status" != "1" ]; then
    hyprlock
fi