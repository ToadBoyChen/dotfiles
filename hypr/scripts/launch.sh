#!/usr/bin/env zsh
set -e
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

hyprctl dispatch layoutmsg "reset"

hyprctl dispatch splitratio 0.5
hyprctl dispatch togglesplit

# First kitty: banner + system update
hyprctl dispatch exec 'kitty --hold zsh -c "
  echo \"\";
  echo \" ╭────────────────────────────────────────────╮\";
  echo \" │ T O A D   L A U N C H   S C R I P T        │\";
  echo \" ╰────────────────────────────────────────────╯\";
  echo \"\";
  echo \"🔁 Running system update...\";
  echo \"\";
  sudo pacman -Syu;
  echo \"\";
  echo \"✅ Update complete.\";
  exec zsh"'

# Second kitty: cbonsai
hyprctl dispatch exec "kitty --hold cbonsai"

