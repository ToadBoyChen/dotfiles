#!/usr/bin/env

set -e
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "⚙️ Setting up your dotfiles from $DOTFILES_DIR"

link_file() {
    local source=$1
    local target=$2

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "🔁 Backing up existing $target → $target.backup"
        mv "$target" "$target.backup"
    fi

    echo "🔗 Linking $target → $source"
    ln -s "$source" "$target"
}

link_file "$DOTFILES_DIR/.config/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

echo "✅ Dotfiles setup complete!"

