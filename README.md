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
- `f pattern` — search from `/` by name while hiding routine IONOS errors

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
f \*.php
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

Exact names need no quoting, for example `f this.txt`. Escape wildcard
characters so Bash passes them to `find`, for example `f this\*`, `f \*.php`,
or `f \*config\*`. Quoting the pattern remains valid but is not required when
you use backslashes.

The function lives in `functions/tree.sh`. It is a sourced Bash function—not a
standalone executable—and `localterm.sh` loads it automatically using its real
location. This also works when `localterm.sh` is reached through a symbolic
link. Normally, you only need to source `localterm.sh`.

## IONOS installation and updates

The IONOS login directory used for this project is
`/kunden/homepages/10/d87402808/htdocs`. Keep the Git checkout one level above
the web root and place a symbolic link to `localterm.sh` in the login directory:

```bash
git clone https://github.com/jaireaux/rollerfeet-shell-tools.git \
  /kunden/homepages/10/d87402808/rollerfeet-shell-tools

cd /kunden/homepages/10/d87402808/htdocs
mv localterm.sh localterm.sh.backup
ln -s ../rollerfeet-shell-tools/localterm.sh localterm.sh
source ./localterm.sh
```

If a file needs to be edited on IONOS, use `vi`, not `nano`:

```bash
vi /kunden/homepages/10/d87402808/rollerfeet-shell-tools/localterm.sh
```

After GitHub changes, update the checkout and reload the tools with:

```bash
git -C /kunden/homepages/10/d87402808/rollerfeet-shell-tools pull --ff-only
source /kunden/homepages/10/d87402808/htdocs/localterm.sh
```

GitHub is the source of truth. Avoid maintaining a separate copied version in
`htdocs`; the symbolic link ensures that a Git pull updates the version loaded
at the next `source` command.

## Notes

These definitions target Bash. The `f` helper uses Bash process substitution,
so source the file from Bash rather than running it with a generic POSIX shell.
The `ls` options are suited to the IONOS/Linux environment for which the file
was created and may differ on other operating systems.

## License

Use and adapt these helpers freely.
