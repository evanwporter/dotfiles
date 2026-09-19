#!/usr/bin/env bash

set -eu

SOURCE=palette.h
TARGETS=("dwm" "dwmblocks" "st" "slock")

for dir in "${TARGETS[@]}"; do
    target="${dir}/$(basename "$SOURCE")"
    rm -f "$target"
    ln "$SOURCE" "$target"
    echo "Linked: $target"
done
