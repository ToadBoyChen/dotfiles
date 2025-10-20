#!/usr/bin/env bash 

echo "Run System Cleaner? (y/n)"
read yes_no_clean

yes_no_clean="${yes_no_clean//$'\r'/}"

if [ "$yes_no_clean" = "y" ] || [ "$yes_no_clean" = "Y" ]; then
    sudo pacman -Sc --noconfirm 
    yay -Sc --noconfirm 
    rm -rf /tmp/*
    rm -rf ~/.cache/thumbnails/*
    rm -rf ~/.local/share/Trash/*
    sudo pacman -Rns $(pacman -Qdtq)
    sudo journalctl --vacuum-time=3d
else
    echo "Skipping System Clean"
fi 

