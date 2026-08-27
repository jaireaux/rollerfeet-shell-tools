#!/usr/bin/env bash

# Handy interactive-shell defaults.
alias ls='ls -GF -w 0'
alias ll='ls -GalhU'
alias l='printf "${GREEN}=%.0s" $(eval echo "{1..$COLUMNS}"); printf "${NOCOLOR}\n"'
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

# Search from the filesystem root by name, hiding routine IONOS errors.
# Quote wildcard patterns when calling it, for example: f '*.php'
f() {
    find / -name "$1" 2>&1 \
        | grep -vE 'Operation not permitted|Permission denied|No such file or directory|Not a directory'
}
