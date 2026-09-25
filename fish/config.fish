if status is-interactive
    set fish_greeting

    alias ls "eza --icons"
    alias ll "eza -la --icons --git"
    alias la "eza -A --icons"
    alias l "eza -CF --icons"

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
set -g theme_display_git_ahead no
set -g theme_display_git_default_branch yes
set -g theme_display_git_dirty no
set -g theme_display_git_untracked no
set -g theme_nerd_fonts yes

set -gx EDITOR nvim
set -gx VISUAL nvim

direnv hook fish | source

# TTY Colors
# if test "$TERM" = linux
#     # Gruvbox Material Dark Medium
#
#     printf '\e]P0282828' # black
#     printf '\e]P1EA6962' # red
#     printf '\e]P2A9B665' # green
#     printf '\e]P3D8A657' # yellow
#     printf '\e]P47DAEA3' # blue
#     printf '\e]P5D3869B' # magenta
#     printf '\e]P689B482' # cyan
#     printf '\e]P7D4BE98' # white
#
#     printf '\e]P8665C54' # bright black / gray
#     printf '\e]P9EA6962' # bright red
#     printf '\e]PAA9B665' # bright green
#     printf '\e]PBD8A657' # bright yellow
#     printf '\e]PC7DAEA3' # bright blue
#     printf '\e]PDD3869B' # bright magenta
#     printf '\e]PE89B482' # bright cyan
#     printf '\e]PFDDC7A1' # bright white
#
#     clear
# end
