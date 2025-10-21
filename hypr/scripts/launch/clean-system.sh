#!/usr/bin/env bash 

echo "Run system clean? (y/n)"
read yes_no_clean

yes_no_clean="${yes_no_clean//$'\r'/}"

if [ "$yes_no_clean" = "y" ] || [ "$yes_no_clean" = "Y" ]; then
    sudo pacman -Sc --noconfirm 
    yay -Sc --noconfirm 
    rm -rf ~/.cache/thumbnails/*
    rm -rf ~/.local/share/Trash/*
    rm -rf /tmp/* 2>/dev/null || true
else
    echo "Skipping system clean..."
fi
