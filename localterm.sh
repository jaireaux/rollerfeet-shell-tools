#!/usr/bin/env bash

# Handy interactive-shell defaults.
alias ls='ls -GF -w 0'
alias ll='ls -GalhU'
alias t='tree'

# Load shell functions relative to this file, regardless of the current directory.
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/functions/tree.sh"

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
