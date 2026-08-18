#!/usr/bin/env bash

# Handy interactive-shell defaults.
alias ls='ls -GF -w 0'
alias ll='ls -GalhU'
alias t='tree'

# A small replacement for tree(1), useful on hosts where tree is unavailable.
# Usage: tree [directory] [depth]
tree() {
    local directory="${1:-.}"
    local depth="${2:-3}"

    if [[ ! -d "$directory" ]]; then
        printf 'tree: not a directory: %s\n' "$directory" >&2
        return 1
    fi

    if [[ ! "$depth" =~ ^[0-9]+$ ]]; then
        printf 'tree: depth must be a non-negative integer: %s\n' "$depth" >&2
        return 2
    fi

    printf '%s\n' "$directory"
    find "$directory" -mindepth 1 -maxdepth "$depth" -print 2>/dev/null \
        | LC_ALL=C sort \
        | awk -v root="$directory" '
            {
                path = $0
                prefix = root
                sub(/\/$/, "", prefix)

                if (prefix == ".") {
                    sub(/^\.\//, "", path)
                } else if (prefix != "") {
                    path = substr(path, length(prefix) + 2)
                }

                level = split(path, parts, "/")
                indent = ""
                for (i = 1; i < level; i++) {
                    indent = indent "|   "
                }
                print indent "+-- " parts[level]
            }
        '
}

# Search interactive shell history, case-insensitively.
h() {
    if (( $# == 0 )); then
        history
    else
        history | grep -i -- "$*"
    fi
}

# Run find while hiding routine permission-denied messages.
f() {
    find "$@" 2> >(grep -v -i 'permission denied' >&2)
}

