# A small replacement for tree(1), useful on hosts where tree is unavailable.
# This file defines a Bash function and is meant to be sourced, not executed.
tree() {
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        cat <<'EOF'
Usage:
  tree [DIRECTORY] [DEPTH]
  tree --help
  tree -h

Display a directory-only tree using standard shell utilities.

Arguments:
  DIRECTORY  Directory to display. Defaults to the current directory (.).
  DEPTH      Maximum number of levels to display. Defaults to 3.

Examples:
  tree
      Show the current directory to a depth of 3.

  tree . 1
      Show only the current directory's immediate subdirectories.

  tree . 2
      Show two levels beneath the current directory.

  tree ~/projects 3
      Show ~/projects to a depth of 3.

  t . 2
      Run the same function using the t alias.

This function is a lightweight replacement for the tree utility on systems
where tree is not installed. It is loaded by sourcing localterm.sh.
EOF
        return 0
    fi

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
    find "$directory" -mindepth 1 -maxdepth "$depth" -type d -print 2>/dev/null \
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
