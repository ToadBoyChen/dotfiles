#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"

validate_dotfile() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "Already linked: $target → $source"
        read -rp "Would you like to reset the symlink? [y/n]: " recreate

        if [[ "$recreate" =~ ^[Yy]$ ]]; then
            echo "Resetting symlink: $target → $source"
            rm "$target"
            ln -sf "$source" "$target"
            echo "🔁 Symlink reset: $target → $source"
        fi
        return
    fi
    
    if [ -e "$target" ] && cmp -s "$target" "$source"; then
        echo "$target matches source but isn’t a symlink — recreating symlink."
        mv "$target" "$target.backup"
        ln -sf "$source" "$target"
        echo "🔗 Created symlink: $target → $source"
        return
    fi

    echo "$target missing or incorrect."
    read -rp "Create symlink now? [y/n]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        ln -sf "$source" "$target"
        echo "🔗 Created symlink: $target → $source"
    fi
}

echo "Validating dotfiles in ~/.config..."

validate_dotfile "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
validate_dotfile "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
# validate_dotfile "$CONFIG_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo "✅ Dotfiles validation complete!"

