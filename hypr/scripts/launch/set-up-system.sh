#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config"

validate_dotfile() {
    local source="$1"
    local target="$2"

    # Symlink already correct
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "✅ Already linked: $target → $source"
        return
    fi

    # File exists and is identical
    if [ -e "$target" ] && cmp -s "$target" "$source"; then
        echo "⚠️ $target matches source but isn’t a symlink."
        read -rp "Replace with symlink? [y/N]: " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            mv "$target" "$target.backup"
            ln -sf "$source" "$target"
        fi
        return
    fi

    # Missing or incorrect
    echo "⚠️ $target missing or incorrect."
    read -rp "Create symlink now? [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        ln -sf "$source" "$target"
        echo "🔗 Created symlink: $target → $source"
    fi
}

echo "⚙️ Validating dotfiles in ~/.config..."

# Zsh
validate_dotfile "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
validate_dotfile "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Neovim
validate_dotfile "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim"

echo "✅ Dotfiles validation complete!"

