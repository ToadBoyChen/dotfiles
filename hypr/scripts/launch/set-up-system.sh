#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "⚙️ Setting up system..."

check_dep() {
    local dep="$1"
    if ! command -v "$dep" &>/dev/null; then
        echo "❌ Missing dependency: $dep"
        return 1
    else
        echo "✅ $dep is installed."
    fi
}

ensure_link() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "✅ Link already correct: $target → $source"
        return
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "🔁 Backing up $target → $target.backup"
        mv "$target" "$target.backup"
    fi

    echo "🔗 Creating symlink: $target → $source"
    ln -sf "$source" "$target"
}

echo "🔍 Checking dependencies..."
DEPS=(git curl wget zsh nvim fastfetch tmux)

missing=0
for dep in "${DEPS[@]}"; do
    if ! check_dep "$dep"; then
        ((missing++))
    fi
done

if ((missing > 0)); then
    echo "⚠️ $missing dependencies missing. Consider installing them manually or adding auto-install logic."
else
    echo "✅ All dependencies are installed!"
fi

echo "🔗 Checking symlinks..."

ensure_link "$DOTFILES_DIR/.config/zsh/.zshrc" "$HOME/.zshrc"
ensure_link "$DOTFILES_DIR/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
ensure_link "$DOTFILES_DIR/.config/nvim" "$CONFIG_DIR/nvim"
ensure_link "$DOTFILES_DIR/.config/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "✅ System setup complete!"

