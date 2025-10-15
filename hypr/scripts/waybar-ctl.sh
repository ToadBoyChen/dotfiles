#!/usr/bin/env bash
set -euo pipefail

# Waybar controller - single point of truth for Waybar changes
# Usage: waybar-ctl.sh {restart|toggle|choose|reload-style}

LOCKFILE="$HOME/.cache/waybar-ctl.lock"
CONFIG_SYMLINK="$HOME/.config/waybar/config"
TEMPLATE_SYMLINK="$HOME/.config/templates/waybar.template"
TEMPLATE_H_DIR="$HOME/.config/templates/horizontal"
TEMPLATE_V_DIR="$HOME/.config/templates/vertical"
APPLY_THEME_SCRIPT="$HOME/.config/hypr/scripts/apply-theme.sh"
CURRENT_THEME_FILE="$HOME/.config/themes/current_theme"

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send "Waybar" "$1" || echo "Waybar: $1"
}

safe_symlink() {
  local target="$1"
  local linkpath="$2"
  ln -sfn "$target" "$linkpath"
}

restart_waybar() {
  notify "Restarting Waybar..."
  pkill -TERM waybar >/dev/null 2>&1 || true
  for i in {1..6}; do
    if pgrep -x waybar >/dev/null 2>&1; then
      sleep 0.1
    else
      break
    fi
  done

  pkill -9 waybar >/dev/null 2>&1 || true


  setsid waybar >/dev/null 2>&1 </dev/null &

  notify "Waybar restarted"
}


apply_current_theme_if_needed() {
    sync 
    sleep 0.1
    if [[ -x "$APPLY_THEME_SCRIPT" && -f "$CURRENT_THEME_FILE" ]]; then
        local curtheme
        curtheme=$(<"$CURRENT_THEME_FILE")

    if [[ -n "$curtheme" ]]; then
        "$APPLY_THEME_SCRIPT" "$curtheme" >/dev/null 2>&1 || {
        notify "Warning: failed to re-run apply-theme for '$curtheme'"
      }
    fi
  fi
}

exec 9>"$LOCKFILE"
if ! flock -x -w 2 9; then
  notify "Another instance is already running."
  exit 1
fi
trap 'flock -u 9; exec 9>&-' EXIT


last_ts_file="${LOCKFILE}.ts"
if [[ -f "$last_ts_file" ]]; then
  last_ts=$(<"$last_ts_file")
else
  last_ts=0
fi
now_ts=$(date +%s)
if (( now_ts - last_ts <= 1 )); then
  sleep 0.45
fi
date +%s >"$last_ts_file"

# --- command dispatch ---
cmd="${1:-help}"

case "$cmd" in
  restart)
    restart_waybar
    ;;

  toggle)
    current_target=""
    if [[ -L "$CONFIG_SYMLINK" || -e "$CONFIG_SYMLINK" ]]; then
      current_target=$(readlink -f "$CONFIG_SYMLINK" 2>/dev/null || true)
    fi

    if [[ "$current_target" == *"-vertical"* ]] || [[ "$current_target" == *"/vertical"* ]]; then
      notify "Waybar: switching to Horizontal layout..."
      safe_symlink "$HOME/.config/waybar/config-horizontal" "$CONFIG_SYMLINK"
      safe_symlink "$HOME/.config/templates/waybar-horizontal.template" "$TEMPLATE_SYMLINK"
    else
      notify "Waybar: switching to Vertical layout..."
      safe_symlink "$HOME/.config/waybar/config-vertical" "$CONFIG_SYMLINK"
      safe_symlink "$HOME/.config/templates/waybar-vertical.template" "$TEMPLATE_SYMLINK"
    fi

    apply_current_theme_if_needed
    restart_waybar
    ;;

  choose)
    orientation=$(printf "Horizontal\nVertical" | wofi --dmenu --prompt "Select Waybar Orientation")
    [[ -z "$orientation" ]] && exit 0

    if [[ "$orientation" == "Horizontal" ]]; then
      template_dir="$TEMPLATE_H_DIR"
      config_target="$HOME/.config/waybar/config-horizontal"
    else
      template_dir="$TEMPLATE_V_DIR"
      config_target="$HOME/.config/waybar/config-vertical"
    fi

    template=$(find "$template_dir" -maxdepth 1 -type f -name "*.template" \
      | sort | sed "s|$template_dir/||" | wofi --dmenu --prompt "Select $orientation Style")

    [[ -z "$template" ]] && exit 0

    safe_symlink "$config_target" "$CONFIG_SYMLINK"
    safe_symlink "$template_dir/$template" "$TEMPLATE_SYMLINK"

    apply_current_theme_if_needed
    restart_waybar

    notify "Waybar set to ${orientation} → ${template}"
    ;;

  reload-style)
    notify "Reloading Waybar style..."
    apply_current_theme_if_needed
    sleep 0.1
    restart_waybar
    ;;

  help|*)
    cat <<EOF
Waybar Controller - single point of truth
Usage:
  $0 restart        Restart Waybar cleanly
  $0 toggle         Toggle between horizontal / vertical layouts
  $0 choose         Choose orientation + template interactively
  $0 reload-style   Reapply current theme + restart Waybar
EOF
    ;;
esac

exit 0

