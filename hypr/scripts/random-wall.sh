#!/bin/bash
WALL_DIR="$HOME/.config/hypr/wallpapers"

# pick a random file
WALL=$(ls "$WALL_DIR" | shuf -n1)

# set wallpaper with smooth transition
swww img "$WALL_DIR/$WALL" --transition-type any --transition-fps 60 --transition-duration 1
