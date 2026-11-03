# Command Shortcuts Reference

A compact cheat sheet for shell commands provided by lingti-code. The
full alias dictionary with every oh-my-zsh entry lives in
[docs/ALIASES.md](ALIASES.md); this file is the "most-reached-for"
subset grouped by task.

Platform tags: `[macOS]` macOS only · `[Linux]` Linux only · everything
else works on both.

---

# 1. Git

Lingti takes over `~/.gitconfig`. Store your name/email in
`~/.gitconfig.user`, secrets in `~/.secrets`. Shortcuts below come from
the oh-my-zsh `git` plugin unless marked **_lingti_** (defined in
`zsh/git.zsh`, `zsh/github-account.zsh`, or `zsh/functions.zsh`).

> **Migration note (2026-01):** moved from Prezto to oh-my-zsh. Six
> aliases silently changed meaning: `grs` (reset → **restore**), `grb`
> (recent-branches → **rebase**), `gra` (rebase --abort → **remote add**),
> `gap` (add -p → **apply**), `gam` (amend → **am**), `gs` (status →
> **unaliased**; use `gst`).

## 1.1 Basic

| Command | Expands to |
|---------|-----------|
| `gst` | `git status` |
| `ga` / `gaa` | `git add` / `git add --all` |
| `gc` | **_lingti_** gitauthor-aware `git commit --verbose` |
| `gcmsg "msg"` | `git commit -m "msg"` |
| `gcam "msg"` | `git commit --all --message "msg"` |
| `gd` / `gds` | `git diff` / `git diff --staged` |
| `glog` | `git log --oneline --decorate --graph` |
| `gsh` | `git show` |

## 1.2 Branch

| Command | Expands to |
|---------|-----------|
| `gb` / `gba` | `git branch` / `git branch --all` |
| `gco <br>` | `git checkout` |
| `gcb <br>` | `git checkout -b` |
| `gswm` | `git switch $(git_main_branch)` |
| `gbd <br>` / `gbD <br>` | delete / force-delete |
| `gbg` | List local branches whose upstream is gone |
| `gbgd` | Delete every "gone" local branch |

## 1.3 Remote (fetch / pull / push)

| Command | Expands to |
|---------|-----------|
| `gf` / `gfa` | `git fetch` / `git fetch --all --tags --prune --jobs=10` |
| `gl` | `git pull` |
| `gpr` / `gpra` | `git pull --rebase` / with `--autostash` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease --force-if-includes` (safer than `--force`) |
| `gpf!` | `git push --force` (dangerous) |
| `gpsup` | `git push --set-upstream origin $(git_current_branch)` |
| `gpoat` | `git push origin --all && git push origin --tags` |

## 1.4 Rebase / merge / cherry-pick

| Command | Expands to |
|---------|-----------|
| `grb` | `git rebase` |
| `grba` / `grbc` / `grbs` | `--abort` / `--continue` / `--skip` |
| `grbi <ref>` | `git rebase --interactive` |
| `grbm` / `grbom` | rebase onto main / origin/main |
| `gm` / `gma` / `gmc` | `git merge` / `--abort` / `--continue` |
| `gmom` | `git merge origin/$(git_main_branch)` |
| `gcp` / `gcpa` / `gcpc` | cherry-pick / abort / continue |

## 1.5 Stash

| Command | Expands to |
|---------|-----------|
| `gsta` | `git stash push` |
| `gstp` | `git stash pop` |
| `gstpu` | `git stash push -u` (include untracked) |
| `gstl` | `git stash list` |
| `gstd` | `git stash drop` |
| `gstaa` | `git stash apply` |
| `gsts` | `git stash show --patch` |
| `gstc` | `git stash clear` |

## 1.6 Reset / restore / clean

| Command | Expands to |
|---------|-----------|
| `grh` / `grhh` / `grhs` | `git reset` / `--hard` / `--soft` |
| `grs` / `grst` | `git restore` / `--staged` |
| `gclean` | `git clean --interactive -d` |
| `gpristine` | `git reset --hard && git clean -dffx` |

## 1.7 Tags / submodules / worktrees

| Command | Expands to |
|---------|-----------|
| `git_tag_add <tag>` | **_lingti_** create tag + push to origin |
| `git_tag_delete <tag>` | **_lingti_** delete tag locally + on origin |
| `gsi` / `gsu` | submodule `init` / `update` |
| `git-change-module-remote <sub> <url>` | **_lingti_** rewrite a submodule's remote |
| `gwt` / `gwta` / `gwtls` / `gwtrm` | worktree / add / list / remove |

## 1.8 Lingti-only additions

| Name | What it does |
|------|-------------|
| `gpr-all [DIR]` | `git pull --rebase --autostash` in every immediate subdir repo |
| `gfr_key <key>` | fetch+rebase using a specific SSH key |
| `gpc_key <key>` | push current branch using a specific SSH key |
| `ghuse [alias]` | per-repo GitHub identity switch (user.email + remote host alias). `-g` → global. Outside a repo → shell env vars for cloning. |
| `ghuse-clear` | drop the env vars set by `ghuse` outside a repo |
| `ghpush <alias> [remote]` | one-shot push using a specific account's SSH key |
| `git_rebase_to_origin [branch]` | rebase current onto `origin/<branch>` |

---

# 2. File Operations

## 2.1 Listing

| Command | Expands to |
|---------|-----------|
| `ll` | `ls -alGh` [macOS] / `ls -alh --color=auto` [Linux] |
| `lh` | `ls -alt \| head` |
| `lsg` | `ll \| grep` |
| `ls_folder_size` | `du -sch .[!.]* * \| sort -h` |
| `find_large_files` | `sudo find / -xdev -type f -size +50M` |

## 2.2 Content

| Command | Description |
|---------|-------------|
| `less` | `less -r` (raw control chars) |
| `tf <file>` | `tail -f` |
| `l` | `less` |
| `gz <path>` | `tar -zcvf` |

---

# 3. Navigation (fasd)

Wired by `zsh/fasd.zsh` — needs `fasd` on PATH. All functions below are
provided by fasd; the single-letter aliases are **_lingti_**.

## 3.1 Basic

| Command | Expands to |
|---------|-----------|
| `a` / `s` | any / show-search-select |
| `d` / `f` | recent directory / file |
| `z <query>` | `cd` to best-matching recent directory |
| `zz` | interactive directory jump |
| `v <query>` | open best-matching recent file in vim |

## 3.2 Examples

```sh
v def conf       =>  vim /some/awkward/path/to/default.conf
z abc            =>  cd /hell/of/a/awkward/path/to/abcdef
vim `f rc lo`    =>  vim /etc/rc.local
mv update.html `d www`
cp `f mov` .
```

---

# 4. Proxy

Functions from `zsh/proxy.zsh`. Matching tmux bindings in
[docs/tmux-keymaps.md](tmux-keymaps.md): `PRE C-p` default 8668, `PRE @`
prompt for port, `PRE C-x` off.

| Command | Description |
|---------|-------------|
| `proxy` | Interactive. Pop up current port (default 8668) to edit |
| `proxy <port>` | Set directly |
| `proxy off` | Unset |
| `proxy status` | Show state |
| `set_proxy [port]` | Underlying setter (HTTP, default 8668) |
| `set_ss_proxy [port]` | SOCKS5 version (default 1080) |
| `unset_proxy` | Clear all proxy env vars |

---

# 5. Docker & Kubernetes

Oh-my-zsh's `docker` plugin is **not** loaded. Only the three convenience
wrappers below exist; everything else uses raw `docker` / `kubectl`.

## 5.1 Docker

| Command | Description |
|---------|-------------|
| `docker-clean` | `docker container prune -f` |
| `docker_purge` | Stop and remove every container |
| `docker_restart_in_mac` | `killall Docker && open /Applications/Docker.app` [macOS] |

## 5.2 Kubernetes (`zsh/k8s.zsh`)

| Command | Description |
|---------|-------------|
| `k` / `kpg` / `ksg` | `kubectl` / `kubectl get pods \| grep` / `kubectl get svc \| grep` |
| `kexec -p <project> -n <ns>` | Exec a shell inside a matching pod |
| `kcp -p <project> -s <src> -d <dst>` | Copy a file from a matching pod |
| `klogs` | Tail logs |
| `ktail <instance> <file>` | Tail a file across every matching pod |
| `kdown <instance> <path> <dir>` | Download a file from every matching pod |
| `k_force_delete_pod <pod>` | Force delete |
| `k_delete_evicted` | Delete evicted pods |

---

# 6. System

## 6.1 Process

| Command | Description |
|---------|-------------|
| `k9 <pid>` | `kill -9` |
| `ka9 <name>` | `killall -9` |
| `pp <name>` | grep processes matching `<name>` |
| `po <pid>` | print `/proc/<pid>/{stdout,stderr}` |
| `top_by_memory` | `top -o %MEM` |

## 6.2 Vim / zsh / lingti

| Command | Description |
|---------|-------------|
| `vim` | `nvim` (lingti alias) |
| `vim_plain` | `vim -u NONE` |
| `ae` | Edit `aliases.zsh` |
| `ze` | Edit `~/.zshrc` |
| `ve` | Edit `~/.vimrc` |
| `ss` | `source ~/.zshrc` (reload current shell) |
| `gar` | Reload every running zsh (`killall -HUP -u $USER zsh`) |

## 6.3 Homebrew

| Command | Description |
|---------|-------------|
| `brewu` | `brew update && upgrade && cleanup && doctor` |

---

# 7. HTTP / network

| Command | Description |
|---------|-------------|
| `chrome_proxy` | Chrome launched with `--proxy-server=http://127.0.0.1:8118` |
| `chrome-cdp` | Chrome with remote debugging port 9222 [macOS] |
| `ssh_by_password` | Force password-only SSH |
| `ssh_copy_id` | `ssh-copy-id -o PreferredAuthentications=password …` |
| `post <url> <data>` | `curl -X POST -H application/json` |

---

# 8. Global aliases

Expand mid-command — handy for piping without typing `|`.

| Alias | Expands to | Example |
|-------|------------|---------|
| `G` | `\| grep` | `ls foo G bar` |
| `L` | `\| less` | `history L` |
| `H` | `\| head` | `cat big.log H` |
| `S` | `\| sort` | `ls S` |
| `C` | `\| wc -l` | `ls C` |
| `N` | `> /dev/null` | `noisy N` |

---

# Appendix: Source files

| What | Where |
|------|-------|
| Core lingti aliases | `~/.lingti/zsh/aliases.zsh` |
| macOS-only aliases | `~/.lingti/zsh/aliases-darwin.zsh` |
| Lingti git additions | `~/.lingti/zsh/git.zsh`, `zsh/github-account.zsh`, `zsh/functions.zsh` |
| fasd integration | `~/.lingti/zsh/fasd.zsh` (not an omz plugin) |
| Proxy functions | `~/.lingti/zsh/proxy.zsh` |
| Kubernetes helpers | `~/.lingti/zsh/k8s.zsh` |
| Oh-my-zsh git plugin (~210 aliases) | `~/.oh-my-zsh/plugins/git/git.plugin.zsh` |
| Oh-my-zsh macos plugin | `~/.oh-my-zsh/plugins/macos/macos.plugin.zsh` |
| Oh-my-zsh ssh-agent plugin | `~/.oh-my-zsh/plugins/ssh-agent/ssh-agent.plugin.zsh` |
