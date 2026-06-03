if status is-interactive
    set fish_greeting

    alias ls "eza --icons"
    alias ll "eza -la --icons --git"
    alias la "eza -A --icons"
    alias l "eza -CF --icons"

    alias cat "bat --paging=never"
end

# -----------------------------
# Environment / PATH
# -----------------------------

# vcpkg
set -gx VCPKG_ROOT "$HOME/vcpkg"
fish_add_path ~/vcpkg

# Linux Homebrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
end

# Rust / Cargo
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
else if test -d "$HOME/.cargo/bin"
    fish_add_path "$HOME/.cargo/bin"
end

# -----------------------------
# Fish Prompt
# -----------------------------

# WSL performance: remove Windows PATH entries that make command lookups slow.
# This keeps prompt themes like bobthefish from scanning /mnt/c on every prompt.
if string match -q '*microsoft*' (uname -r | string lower)
    set -gx PATH (string match -v '/mnt/c/*' $PATH)
end

set -g theme_color_scheme catpuccin-frappe
set -g theme_display_git yes
set -g theme_display_git_default_branch yes
set -g theme_display_git_dirty no
set -g theme_display_git_untracked no
set -g theme_nerd_fonts yes
