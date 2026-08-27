# rollerfeet-shell-tools

Small Bash helpers for shared-hosting command lines.

This project grew out of working in an IONOS shared-hosting shell, where useful
utilities such as `tree` may not be installed and installing system packages is
usually not an option. `localterm.sh` provides a lightweight `tree` replacement
using commands commonly available on shared hosting, plus a few convenient
aliases and search helpers.

## What it includes

- `ls` — colorized, classified, full-width directory listings
- `ll` — a detailed listing that includes hidden files
- `l` — a colored horizontal separator across the terminal
- `t` — a short alias for the included `tree` function
- `tree [directory] [depth]` — a directory-only tree built with `find`, `sort`, and
  `awk`; the defaults are the current directory and three levels
- `tree --help` or `tree -h` — built-in usage instructions and examples
- `h [text]` — case-insensitive shell-history search (or all history with no text)
- `f 'pattern'` — search from `/` by name while hiding routine IONOS errors

## Install

Clone the repository into your home directory:

```bash
git clone https://github.com/jaireaux/rollerfeet-shell-tools.git ~/.rollerfeet-shell-tools
```

Then source the file from `~/.bashrc`:

```bash
printf '\nsource "$HOME/.rollerfeet-shell-tools/localterm.sh"\n' >> ~/.bashrc
source ~/.bashrc
```

If your host starts login shells without reading `~/.bashrc`, add the same
`source` line to `~/.bash_profile` instead.

To try the tools for only the current shell session:

```bash
source ./localterm.sh
```

## Examples

```bash
ll
l
t
tree public_html 2
tree --help
h ssh
f '*.php'
```

Example tree output:

```text
public_html
+-- assets
|   +-- css
|   |   +-- site.css
|   +-- images
+-- index.php
```

The replacement intentionally stays simple and portable: it passes the chosen
directory and maximum depth to `find`, selects directories with `-type d`, sorts
the paths for stable output, and uses `awk` to render familiar `|` and `+--`
branches. It does not require the standalone `tree` program.

Quote wildcard patterns passed to `f`, such as `f '*.php'`. The quotes prevent
the shell from expanding the pattern before `find` receives it.

The function lives in `functions/tree.sh`. It is a sourced Bash function—not a
standalone executable—and `localterm.sh` loads it automatically using a path
relative to its own location. Normally, you only need to source `localterm.sh`.

## Notes

These definitions target Bash. The `f` helper uses Bash process substitution,
so source the file from Bash rather than running it with a generic POSIX shell.
The `ls` options are suited to the IONOS/Linux environment for which the file
was created and may differ on other operating systems.

## License

Use and adapt these helpers freely.
