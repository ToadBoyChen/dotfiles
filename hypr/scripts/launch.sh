#!/usr/bin/env zsh
set -e
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

echo ""
echo "╭────────────────────────────────────────────╮"
echo "│      🐸  T O A D   L A U N C H   S C R I P T  🐸      │"
echo "╰────────────────────────────────────────────╯"
echo ""

hyprctl dispatch layoutmsg "reset"

hyprctl dispatch splitratio 0.5
hyprctl dispatch togglesplit
hyprctl dispatch exec "kitty --hold"

hyprctl dispatch exec "kitty --hold cbonsai"

sleep 1
exit

