# Command Shortcuts Reference

Complete shell command aliases and functions for Lingti configuration.

**Note:** Some commands may be OS-specific. Marked with:
- `[macOS]` - macOS only
- `[Linux]` - Linux only
- `[All]` - Works on all platforms

---

# 1. Git

Lingti will take over your `~/.gitconfig`. Store your git username and other settings in `~/.gitconfig.user`. Set environment variables in `~/.secrets`.

## 1.1 Basic Operations

| Command | Expands To | Description |
|---------|------------|-------------|
| `ga` | `git add` | Stage files |
| `gc` | `git commit --verbose` | Commit with diff |
| `gd` | `git diff` | Show changes |
| `gl` | `git log` | View history |
| `gco` | `git checkout` | Switch branches/restore files |

## 1.2 Branch Operations

| Command | Expands To | Description |
|---------|------------|-------------|
| `gb` | `git branch` | List branches |
| `gbc` / `gnb` | `git checkout -b` | Create new branch |
| `gbs` | `git show-branch` | Show branch history |

## 1.3 Remote Operations

| Command | Expands To | Description |
|---------|------------|-------------|
| `gf` | `git fetch` | Fetch from remote |
| `gfc` | `git clone` | Clone repository |
| `gfm` | `git pull` | Pull changes |
| `gfr` | `git pull --rebase` | Pull with rebase |
| `gpc` | `git push --set-upstream origin "$(git-branch-current)"` | Push current branch |

## 1.4 Rebase Operations

| Command | Expands To | Description |
|---------|------------|-------------|
| `gr` | `git rebase` | Rebase branch |
| `gra` | `git rebase --abort` | Abort rebase |
| `grc` | `git rebase --continue` | Continue rebase |
| `grs` | `git rebase --skip` | Skip current commit |
| `gcp` | `git cherry-pick --ff` | Cherry pick commit |

## 1.5 Stash Operations

| Command | Expands To | Description |
|---------|------------|-------------|
| `gst` | `git stash` | Stash changes |
| `gsp` | `git stash pop` | Pop stash |
| `gsl` | `git stash list` | List stashes |
| `gsd` | `git stash drop` | Drop stash |

## 1.6 Tag Operations

| Command | Description |
|---------|-------------|
| `git_tag_add` | Add GitHub tag |
| `git_tag_delete` | Delete GitHub tag |

---

# 2. File Operations

## 2.1 File Management

| Command | Args | Description |
|---------|------|-------------|
| `swap` | `FILE1 FILE2` | Swap two files |

## 2.2 Replace (Text Substitution)

The `Replace` command performs recursive text replacement in files.

**Usage:** `Replace [options]`

| Option | Description |
|--------|-------------|
| `-f` | File regex pattern |
| `-s` | Source pattern |
| `-d` | Destination pattern |
| `-r` | Remove line |
| `--regex` | Match pattern with regex |
| `--seperator=` | Separator (`#` by default) |
| `-h` | Display help message |

---

# 3. Navigation (fasd)

[fasd](https://github.com/clvv/fasd) provides quick access to frequently used files and directories.

## 3.1 Basic Commands

| Command | Expands To | Description |
|---------|------------|-------------|
| `a` | `fasd -a` | Any (files/directories) |
| `s` | `fasd -si` | Show / search / select |
| `d` | `fasd -d` | Directory |
| `f` | `fasd -f` | File |

## 3.2 Interactive Selection

| Command | Expands To | Description |
|---------|------------|-------------|
| `sd` | `fasd -sid` | Interactive directory selection |
| `sf` | `fasd -sif` | Interactive file selection |
| `z` | `fasd_cd -d` | cd (like autojump's `j`) |
| `zz` | `fasd_cd -d -i` | cd with interactive selection |

## 3.3 Examples

```sh
v def conf       =>  vim /some/awkward/path/to/type/default.conf
j abc            =>  cd /hell/of/a/awkward/path/to/get/to/abcdef
m movie          =>  mplayer /whatever/whatever/whatever/awesome_movie.mp4
o eng paper      =>  xdg-open /you/dont/remember/where/english_paper.pdf
vim `f rc lo`    =>  vim /etc/rc.local
vim `f rc conf`  =>  vim /etc/rc.conf
mv update.html `d www`
cp `f mov` .
```

---

# 4. Network

| Command | Args | Description | OS |
|---------|------|-------------|-----|
| `test-port` | `PORT` | Test whether PORT is opened | All |
| `intercept-request-hosts` | - | Intercept requests and show hosts | All |
| `host-ip` | - | Show host IP of your system | All |

---

# 5. Proxy

| Command | Description |
|---------|-------------|
| `set_proxy` | Set terminal proxy using HTTP proxy |
| `set_vagrant_proxy` | Set terminal proxy using Vagrant HTTP proxy |
| `set_ss_proxy` | Set terminal proxy using SOCKS proxy |
| `unset_proxy` | Cancel all proxy settings |

---

# 6. System

## 6.1 Script Helpers

| Command | Description |
|---------|-------------|
| `yell` | Print script name and all arguments to stderr |
| `die` | Same as yell, but exits with non-0 status (fail) |
| `try` | Uses `\|\|` (boolean OR), only evaluates right side if left fails |

## 6.2 File System

| Command | Args | Description |
|---------|------|-------------|
| `list-large-files` | `DIR` | List large files sorted by size (KB, MB, GB) |

---

# 7. String

| Command | Args | Description |
|---------|------|-------------|
| `random-hex` | - | Print random hex string |
| `random-string` | - | Print random string of `a-zA-Z0-9` |
| `contains` | `str1 str2 ... target` | Test if target is in string array |

---

# 8. Docker & Kubernetes

## 8.1 Docker

| Command | Description |
|---------|-------------|
| `dc` | Alias for `docker-compose` |
| `docker_rm_all` | Delete all docker images |

## 8.2 Kubernetes

| Command | Description |
|---------|-------------|
| `kexec` | Execute k8s pod by regex pod name |
| `klog` | Show k8s pod log by regex pod name |

---

# 9. Process & HTTP

| Command | Args | Description |
|---------|------|-------------|
| `pp` | `NAME` | Grep process by name (`pp nginx`) |
| `post` | `URL DATA` | curl POST with `application/json` |

---

# 10. Shell & Config

| Command | Description |
|---------|-------------|
| `secure_source` | Source `~/.lingti/zsh/function.zsh` to apply changes immediately |
| `ae` | Edit aliases |
| `ar` | Reload aliases |

---

# Appendix: Source Files

| Category | Source File |
|----------|-------------|
| Files | `~/.lingti/zsh/files.zsh` |
| Functions | `~/.lingti/zsh/function.zsh` |
| Git | `~/.zprezto/modules/git/alias.zsh` |
| fasd | `~/.zprezto/modules/fasd/init.zsh` |
