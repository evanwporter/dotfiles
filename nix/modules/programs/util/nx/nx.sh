#!/usr/bin/env bash

set -e

FLAKE="/home/evanp/dotfiles/nix"
HOST="laptop"

case "$1" in
update)
    if [ -z "$2" ]; then
        echo "Usage: nx update <package-attribute-path>"
        exit 1
    fi

    cd ~/nixpkgs

    nix-shell maintainers/scripts/update.nix \
        --argstr package "$2"
    ;;

pull)
    nix flake update \
        --flake "$FLAKE"
    ;;

outdated)
    if ! command -v jq >/dev/null 2>&1; then
        echo "nx outdated requires jq."
        exit 1
    fi

    extract_expr='
        sys:
        let
          lib = sys.pkgs.lib;
          nixpkgs = toString sys.pkgs.path;

          mine = d: !(lib.hasPrefix nixpkgs d.file);

          defs =
            sys.options.environment.systemPackages.definitionsWithLocations;

          systemPackages =
            lib.concatMap
              (d: d.value)
              (lib.filter mine defs);

          userPackages =
            lib.concatLists
              (lib.mapAttrsToList
                (_: user: user.packages or [])
                sys.config.users.users);

          name = p:
            p.pname or (lib.getName p);

        in
          lib.listToAttrs (
            map
              (p: lib.nameValuePair
                (name p)
                (p.version or ""))
              (systemPackages ++ userPackages)
          )
    '

    echo "Checking packages in current configuration..."

    current=$(
        nix eval \
            --json \
            --no-warn-dirty \
            --no-write-lock-file \
            "$FLAKE#nixosConfigurations.$HOST" \
            --apply "$extract_expr"
    )

    echo "Checking current nixos-unstable..."

    upstream=$(
        nix eval \
            --json \
            --no-warn-dirty \
            --no-write-lock-file \
            --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable \
            "$FLAKE#nixosConfigurations.$HOST" \
            --apply "$extract_expr"
    )

    mapfile -t changes < <(
        jq -rn \
            --argjson current "$current" \
            --argjson upstream "$upstream" \
            '
            [
              $current
              | to_entries[]
              | .key as $name
              | .value as $old
              | ($upstream[$name] // null) as $new

              # Ignore packages without meaningful versions and
              # packages whose versions have not changed.
              | select(
                  $old != "" and
                  $old != $new
                )

              | [
                  $name,
                  $old,
                  ($new // "gone from unstable")
                ]
            ]
            | sort_by(.[0])
            | .[]
            | @tsv
            '
    )

    if ((${#changes[@]} == 0)); then
        echo
        echo "Everything is up to date."
        exit 0
    fi

    # Work out the longest package name for aligned output.
    width=0

    for row in "${changes[@]}"; do
        IFS=$'\t' read -r name old new <<<"$row"

        if ((${#name} > width)); then
            width=${#name}
        fi
    done

    echo

    for row in "${changes[@]}"; do
        IFS=$'\t' read -r name old new <<<"$row"

        printf "%-${width}s  %s -> %s\n" \
            "$name" \
            "$old" \
            "$new"
    done

    echo
    echo "${#changes[@]} package(s) would change."
    echo "Run 'nx pull' to update."
    ;;

test)
    sudo nixos-rebuild test \
        --flake "$FLAKE#$HOST" \
        --impure
    ;;

rebuild)
    sudo nixos-rebuild switch \
        --flake "$FLAKE#$HOST" \
        --impure
    ;;

clean)
    echo "Keeping the newest 5 NixOS system generations..."

    before=$(df -B1 --output=avail /nix/store | tail -n1)

    mapfile -t generations < <(
        sudo nix-env \
            --profile /nix/var/nix/profiles/system \
            --list-generations |
            awk '{print $1}'
    )

    if ((${#generations[@]} > 5)); then
        old_generations=(
            "${generations[@]:0:${#generations[@]}-5}"
        )

        echo "Deleting system generations: ${old_generations[*]}"

        sudo nix-env \
            --profile /nix/var/nix/profiles/system \
            --delete-generations "${old_generations[@]}"
    else
        echo "Only ${#generations[@]} system generations exist; nothing to delete."
    fi

    echo "Collecting unreachable Nix store paths..."
    sudo nix-collect-garbage

    echo "Optimising Nix store..."
    sudo nix-store --optimise

    after=$(df -B1 --output=avail /nix/store | tail -n1)
    reclaimed=$((after - before))

    echo
    echo "Nix trash taken out."
    echo "$(numfmt --to=iec-i --suffix=B "$after") free"
    echo "$(numfmt --to=iec-i --suffix=B "$reclaimed") reclaimed"
    ;;

rollback)
    sudo nixos-rebuild switch --rollback
    ;;

review)
    if [ -z "$2" ]; then
        echo "Usage: nx review <pr-number>"
        exit 1
    fi

    pr="$2"

    echo "Looking up nixpkgs PR #$pr..."

    title=$(
        gh pr view "$pr" \
            --repo NixOS/nixpkgs \
            --json title \
            --jq '.title'
    )

    echo "PR: $title"

    extra_args=""

    # Match titles beginning with something such as:
    #
    #   vimPlugins.blink-lib: 1.2.3 -> 1.2.4
    #   vimPlugins.foo: init at ...
    #
    if [[ "$title" =~ ^(vimPlugins\.[^:\ ]+) ]]; then
        package="${BASH_REMATCH[1]}"
        extra_args="-p $package"

        echo "Detected vim plugin: $package"
        echo "Using nixpkgs-review args: $extra_args"
    fi

    echo "Starting GitHub Actions review..."

    if [ -n "$extra_args" ]; then
        gh workflow run review.yml \
            --repo evanwporter/nixpkgs-review-gha \
            -f "pr=$pr" \
            -f "extra-args=$extra_args"
    else
        gh workflow run review.yml \
            --repo evanwporter/nixpkgs-review-gha \
            -f "pr=$pr"
    fi

    echo "Review submitted."
    ;;

version)
    commit=$(git -C ~/dotfiles rev-parse --short HEAD)
    branch=$(git -C ~/dotfiles branch --show-current)

    echo "dotfiles ($branch) $commit"
    ;;

*)
    echo "Usage: nx <command>"
    echo
    echo "Commands:"
    echo "  update <package>   Update a nixpkgs package"
    echo "  pull               Update flake inputs"
    echo "  outdated           Show packages that would change after updating nixpkgs"
    echo "  test               Temporarily activate NixOS configuration"
    echo "  rebuild            Rebuild and switch NixOS configuration"
    echo "  clean              Keep last 5 generations and clean Nix store"
    echo "  rollback           Switch back to the previous NixOS generation"
    echo "  review <pr>        Run nixpkgs-review GitHub Action for a PR"
    echo "  version            Show dotfiles Git commit"
    exit 1
    ;;
esac
