#!/usr/bin/env bash

# Handy interactive-shell defaults.
alias ls='ls -GF -w 0'
alias ll='ls -GalhU'
alias l='printf "${GREEN}=%.0s" $(eval echo "{1..$COLUMNS}"); printf "${NOCOLOR}\n"'
alias t='tree'

# Resolve this file's real location before loading functions. This keeps the
# relative include working even when localterm.sh is reached through a symlink.
_rollerfeet_source="${BASH_SOURCE[0]}"
while [[ -L "$_rollerfeet_source" ]]; do
    _rollerfeet_dir="$(cd -P -- "$(dirname -- "$_rollerfeet_source")" && pwd)"
    _rollerfeet_source="$(readlink -- "$_rollerfeet_source")"
    [[ "$_rollerfeet_source" != /* ]] && _rollerfeet_source="$_rollerfeet_dir/$_rollerfeet_source"
done
_rollerfeet_dir="$(cd -P -- "$(dirname -- "$_rollerfeet_source")" && pwd)"
source "$_rollerfeet_dir/functions/tree.sh"
unset _rollerfeet_source _rollerfeet_dir

# Search interactive shell history, case-insensitively.
h() {
    if (( $# == 0 )); then
        history
    else
        history | grep -i -- "$*"
    fi
}

# Search from the filesystem root by name, hiding routine IONOS errors.
# Escape or quote wildcard patterns so Bash passes them unchanged: f \*.php
f() {
    find / -name "$1" 2>&1 \
        | grep -vE 'Operation not permitted|Permission denied|No such file or directory|Not a directory'
}
