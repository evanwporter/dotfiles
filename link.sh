#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_file() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest")"

        if [ "$current_target" = "$src" ]; then
            echo "Already linked: $dest -> $src"
            return
        fi

        echo "Replacing existing symlink: $dest"
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "Backing up existing file: $dest"
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi

    ln -s "$src" "$dest"
    echo "Linked: $dest -> $src"
}

link_file "$DOTFILES_DIR/nvim/" "$HOME/.config/nvim"
# link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
# link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
link_file "$DOTFILES_DIR/fish" "$HOME/.config/fish"
link_file "$DOTFILES_DIR/lazygit" "$HOME/.config/lazygit"
# link_file "/etc/nixos" "$HOME/.config/nixos"
link_file "$DOTFILES_DIR/alejandra" "$HOME/.config/alejandra"
link_file "$DOTFILES_DIR/delta" "$HOME/.config/delta"
link_file "$DOTFILES_DIR/bat" "$HOME/.config/bat"
link_file "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"
# link_file "$DOTFILES_DIR/nvimpager" "$HOME/.config/nvimpager"
# link_file "$DOTFILES_DIR/glow" "$HOME/.config/glow"

echo
echo "Done."
echo "Backups, if any, are in: $BACKUP_DIR"
