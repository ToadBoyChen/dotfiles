#!/bin/bash

# A centralized script to manage the Waybar process.
# This is the ONLY script that should ever kill, reload, or launch Waybar.

WAYBAR_LAUNCHER="$HOME/.config/waybar/launch.sh"

# --- Main Logic ---
case "$1" in
    restart)
        # Check if we should be silent
        if [[ "$2" != "--silent" ]]; then
            notify-send "Waybar" "Restarting..."
        fi
        
        # 1. Kill the bar AND WAIT for it to die completely.
        killall -q waybar
        while pgrep -x waybar >/dev/null; do sleep 0.1; done

        # 2. Relaunch Waybar using your dedicated launch script.
        setsid "$WAYBAR_LAUNCHER" >/dev/null 2>&1 &
        
        if [[ "$2" != "--silent" ]]; then
            notify-send "Waybar" "Restart Complete!"
        fi
        ;;

    reload-style)
        if [[ "$2" != "--silent" ]]; then
            notify-send "Waybar" "Reloading Style..."
        fi
        
        # Check if Waybar is running before sending a signal
        if pgrep -x waybar >/dev/null; then
            # Use SIGUSR2 to ask Waybar to reload its style.css
            killall -SIGUSR2 waybar
        else
            # If Waybar isn't running, just start it.
            setsid "$WAYBAR_LAUNCHER" >/dev/null 2>&1 &
        fi
        ;;

    *)
        echo "Usage: $0 {restart|reload-style} [--silent]"
        exit 1
        ;;
esac