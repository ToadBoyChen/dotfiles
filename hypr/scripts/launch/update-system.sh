#!/usr/bin/env bash

echo "Run system update? (y/n)"
read yes_no_update

yes_no_update="${yes_no_update//$'\r'/}"

if [ "$yes_no_update" = "y" ] || [ "$yes_no_update" = "Y" ]; then
    sudo pacman -Syu --noconfirm --needed
    yay -Syu --devel --noconfirm
    hyprpm update && hyprpm upgrade
else
    echo "Skipping system update..."
fi
