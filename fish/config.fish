if status is-interactive
    set fish_greeting

    alias ls "eza --icons"
    alias ll "eza -la --icons --git"
    alias la "eza -A --icons"
    alias l "eza -CF --icons"

    alias cat "bat --paging=never"

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"

        if read -z cwd <"$tmp"; and test "$cwd" != "$PWD"; and test -d "$cwd"
            builtin cd -- "$cwd"
        end

        command rm -f -- "$tmp"
    end
end

# -----------------------------
# Environment / PATH
# -----------------------------

# vcpkg
if type -q vcpkg
    set -gx VCPKG_ROOT (dirname (dirname (which vcpkg)))
end

# -----------------------------
# Fish Prompt
# -----------------------------

# WSL performance: remove Windows PATH entries that make command lookups slow.
# This keeps prompt themes like bobthefish from scanning /mnt/c on every prompt.
if string match -q '*microsoft*' (uname -r | string lower)
    set -gx PATH (string match -v '/mnt/c/*' $PATH)
end

set -g theme_color_scheme gruvbox
set -g theme_display_git yes
set -g theme_display_git_default_branch yes
set -g theme_display_git_dirty no
set -g theme_display_git_untracked no
set -g theme_nerd_fonts yes

set -gx EDITOR nvim
set -gx VISUAL nvim
