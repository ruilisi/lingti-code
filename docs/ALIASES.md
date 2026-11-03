# Shell Aliases Reference

The authoritative reference for every alias and function reachable from a
fresh lingti-code shell. Rows marked **_lingti_** are defined by this repo;
the rest come from oh-my-zsh's `git`, `macos`, `ssh-agent`,
`zsh-syntax-highlighting` and `zsh-history-substring-search` plugins listed
in `zsh/zshrc`.

> Verify any row with `zsh -ic 'type <alias>'`. The oh-my-zsh git plugin
> ships ~210 aliases; the table below documents the ~60 highest-value
> ones. For the full list see `~/.oh-my-zsh/plugins/git/git.plugin.zsh`.

## Table of Contents

- [Quick Reference](#quick-reference)
- [Prompt Toggle](#prompt-toggle)
- [Lingti Management](#lingti-management)
- [Navigation](#navigation)
- [File Listing](#file-listing)
- [Git](#git)
  - [Lingti git additions](#lingti-git-additions)
- [Kubernetes](#kubernetes)
- [Fasd (Quick Navigation)](#fasd-quick-navigation)
- [Docker](#docker)
- [Ruby / Rails](#ruby--rails)
- [Node.js](#nodejs)
- [System Utilities](#system-utilities)
- [Proxy](#proxy)
- [Global Aliases](#global-aliases)
- [macOS Specific](#macos-specific)

---

## Quick Reference

The ten aliases you'll reach for most often:

| Alias | Command | Why |
|-------|---------|-----|
| `gst` | `git status` | What has changed |
| `gaa` | `git add --all` | Stage everything |
| `gcmsg` | `git commit -m` | Commit with message |
| `gp` | `git push` | Ship it |
| `gpr` | `git pull --rebase` | Catch up without a merge commit |
| `gco <branch>` | `git checkout` | Switch branches |
| `gcb <branch>` | `git checkout -b` | New branch and switch |
| `gd` | `git diff` | What's different in the worktree |
| `glog` | `git log --oneline --decorate --graph` | Quick history view |
| `gpr-all` | run `git pull --rebase` in every immediate subdir repo | _lingti_ — sync a workspace |

---

## Prompt Toggle

Driven by oh-my-zsh's `agnoster` theme — toggles live in `zsh/zsh-aliases.zsh`.

| Alias | Command | Description |
|-------|---------|-------------|
| `show_username` | `SHOW_USERNAME=1; prompt_setup` | Show username in prompt |
| `hide_username` | `SHOW_USERNAME=0; prompt_setup` | Hide username (default) |
| `show_kcontext` | `SHOW_KCONTEXT=1; prompt_setup` | Show kubernetes context |
| `hide_kcontext` | `SHOW_KCONTEXT=0; prompt_setup` | Hide kubernetes context (default) |

---

## Lingti Management

All rows below are **_lingti_**.

| Alias | Command | Description |
|-------|---------|-------------|
| `lav` | `lingti vim-add-plugin` | Add vim plugin |
| `ldv` | `lingti vim-delete-plugin` | Delete vim plugin |
| `llv` | `lingti vim-list-plugin` | List vim plugins |
| `lup` | `lingti update-plugins` | Update all plugins |
| `lip` | `lingti init-plugins` | Initialize plugins |
| `ae` | `vim ~/.lingti/zsh/aliases.zsh` | Edit aliases file |
| `edit_alias` | `vim aliases.zsh functions.zsh -p` | Edit aliases and functions |
| `gar` | `killall -HUP -u "$USER" zsh` | Reload all zsh instances (apply alias changes everywhere) |
| `ss` | `source ~/.zshrc` | Reload the current shell |
| `ze` | `vim ~/.zshrc` | Edit zshrc |
| `ve` | `vim ~/.vimrc` | Edit vimrc |

---

## Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `cdb` | `cd -` | Go to previous directory _(lingti)_ |
| `cls` | `clear; ls` | Clear screen and list files _(lingti)_ |
| `cl` | `clear` | Clear screen _(lingti)_ |
| `..` | `cd ..` | Up one directory |
| `...` | `cd ../..` | Up two directories |
| `....` | `cd ../../..` | Up three directories |
| `.....` | `cd ../../../..` | Up four directories |
| `-` | `cd -` | Previous directory |
| `1` – `9` | `cd -N` | Jump to the Nth entry in the dirstack |
| `d` | print the dirstack | (shadowed by fasd — see Fasd section) |
| `md <dir>` | `mkdir -p <dir>` | Make parent dirs as needed |
| `rd <dir>` | `rmdir <dir>` | Remove empty directory |

---

## File Listing

All macOS defaults from `zsh/aliases-darwin.zsh`.

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -alGh` (macOS) / `ls -alh --color=auto` (Linux) | Long list with human sizes |
| `ls` | `ls -Gh` (macOS) / `ls --color=auto` (Linux) | Colored list |
| `lsg` | `ll \| grep` | List and grep |
| `lh` | `ls -alt \| head` | Last modified files |
| `lp` | `ls --hide="*.pyc"` | List hiding pyc files |

---

## Git

Everything in this section is oh-my-zsh unless marked **_lingti_**. The
oh-my-zsh git plugin is at `~/.oh-my-zsh/plugins/git/git.plugin.zsh`.

> **Migration note (2026-01):** lingti moved from Prezto to oh-my-zsh. Six
> aliases quietly changed meaning: `grs` was `git reset`, now `git restore`;
> `grb` was `git recent-branches`, now `git rebase`; `gra` was `git rebase
> --abort`, now `git remote add`; `gap` was `git add -p`, now `git apply`;
> `gam` was `git amend --reset-author`, now `git am`; `gs` is no longer
> aliased — use `gst` for `git status`.

### Status, log, diff

| Alias | Command |
|-------|---------|
| `gst` | `git status` |
| `gss` | `git status -s` |
| `gsb` | `git status -sb` |
| `glog` | `git log --oneline --decorate --graph` |
| `gloga` | `git log --oneline --decorate --graph --all` |
| `glol` | `git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'` |
| `glols` | `glol --stat` |
| `glgp` | `git log --stat -p` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gdca` | `git diff --cached` |
| `gdw` | `git diff --word-diff` |
| `gdt` | `git diff-tree --no-commit-id --name-only -r` |
| `gsh` | `git show` |
| `grv` | `git remote --verbose` |

### Add, commit, amend

| Alias | Command |
|-------|---------|
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gav` | `git add --verbose` |
| `gapa` | `git add --patch` |
| `gau` | `git add --update` |
| `gc` | **_lingti_** gitauthor-aware `git commit --verbose` wrapper |
| `gcmsg` | `git commit -m` |
| `gcam` | `git commit --all --message` |
| `gca` | `git commit --verbose --all` |
| `gc!` | `git commit --verbose --amend` |
| `gca!` | `git commit --verbose --all --amend` |
| `gcn!` | `git commit --verbose --no-edit --amend` |
| `gcan!` | `git commit --verbose --all --no-edit --amend` |
| `gcs` | `git commit --gpg-sign` |
| `gcm <msg>` | **_lingti_** `gc --message <msg>` (watch out — oh-my-zsh's default `gcm` is `git checkout main`; lingti overrides it) |

### Branches, checkout, switch

| Alias | Command |
|-------|---------|
| `gb` | `git branch` |
| `gba` | `git branch --all` |
| `gbd <br>` | `git branch --delete` |
| `gbD <br>` | `git branch --delete --force` |
| `gbr` | `git branch --remotes` |
| `gbm` | `git branch --move` |
| `gbg` | `LANG=C git branch -vv \| grep ": gone\]"` (list local branches whose upstream is gone) |
| `gbgd` | delete every "gone" local branch |
| `gco <br>` | `git checkout` |
| `gcb <br>` | `git checkout -b` |
| `gcor <br>` | `git checkout --recurse-submodules` |
| `gswc <br>` | `git switch -c` (new branch) |
| `gsw <br>` | `git switch` |
| `gswm` | `git switch $(git_main_branch)` |

### Fetch, pull, push

| Alias | Command |
|-------|---------|
| `gf` | `git fetch` |
| `gfa` | `git fetch --all --tags --prune --jobs=10` |
| `gfo` | `git fetch origin` |
| `gl` | `git pull` |
| `gpr` | `git pull --rebase` |
| `gpra` | `git pull --rebase --autostash` |
| `gprv` | `git pull --rebase -v` |
| `gp` | `git push` |
| `gpd` | `git push --dry-run` |
| `gpf` | `git push --force-with-lease --force-if-includes` |
| `gpf!` | `git push --force` |
| `gpoat` | `git push origin --all && git push origin --tags` |
| `gpu` | `git push upstream` |
| `gpsup` | `git push --set-upstream origin $(git_current_branch)` |
| `gpsupf` | `git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes` |

### Stash

| Alias | Command |
|-------|---------|
| `gsta` | `git stash push` |
| `gstaa` | `git stash apply` |
| `gstc` | `git stash clear` |
| `gstd` | `git stash drop` |
| `gstl` | `git stash list` |
| `gstp` | `git stash pop` |
| `gstpu` | `git stash push -u` (include untracked) |
| `gsts` | `git stash show --patch` |

### Rebase, merge, cherry-pick

| Alias | Command |
|-------|---------|
| `grb` | `git rebase` |
| `grba` | `git rebase --abort` |
| `grbc` | `git rebase --continue` |
| `grbs` | `git rebase --skip` |
| `grbi <ref>` | `git rebase --interactive` |
| `grbo <ref>` | `git rebase --onto` |
| `grbm` | `git rebase $(git_main_branch)` |
| `grbom` | `git rebase origin/$(git_main_branch)` |
| `gm` | `git merge` |
| `gms` | `git merge --squash` |
| `gma` | `git merge --abort` |
| `gmc` | `git merge --continue` |
| `gmom` | `git merge origin/$(git_main_branch)` |
| `gcp` | `git cherry-pick` |
| `gcpa` | `git cherry-pick --abort` |
| `gcpc` | `git cherry-pick --continue` |

### Reset, restore, clean

| Alias | Command |
|-------|---------|
| `grh` | `git reset` |
| `grhh` | `git reset --hard` |
| `grhk` | `git reset --keep` |
| `grhs` | `git reset --soft` |
| `grs` | `git restore` |
| `grss` | `git restore --source` |
| `grst` | `git restore --staged` |
| `gclean` | `git clean --interactive -d` |
| `gpristine` | `git reset --hard && git clean -dffx` |

### Remotes

| Alias | Command |
|-------|---------|
| `gr` | `git remote` |
| `gra` | `git remote add` |
| `grrm` | `git remote remove` |
| `grrn` | `git remote rename` |
| `grset` | `git remote set-url` |
| `grup` | `git remote update` |

### Submodules, worktrees, tags

| Alias | Command |
|-------|---------|
| `gsi` | `git submodule init` |
| `gsu` | `git submodule update` |
| `gwt` | `git worktree` |
| `gwta` | `git worktree add` |
| `gwtls` | `git worktree list` |
| `gwtrm` | `git worktree remove` |
| `gtv` | `git tag \| sort -V` |
| `gts` | `git tag --sign` |
| `gtl <pattern>` | list tags matching a glob |

### Lingti git additions

Every row below is **_lingti_**, defined in `zsh/git.zsh`,
`zsh/github-account.zsh`, or `zsh/functions.zsh`.

| Name | What it does |
|------|-------------|
| `gpr-all [DIR]` | `git pull --rebase --autostash` in every immediate subdirectory git repo. Default DIR = current directory. Prints a summary of ok / failed / skipped |
| `gfr_key <key>` | `git pull --rebase` with a specific SSH key |
| `gpc_key <key>` | `git push` current branch with a specific SSH key |
| `ghuse [alias]` | Switch GitHub identity for the **current repo** (sets local `user.name/email`, rewrites every remote URL to the account's SSH host alias). No arg → show current + list accounts. `-g` → set global instead. Outside a repo → export `GIT_AUTHOR_*` / `GIT_SSH_COMMAND` for this shell |
| `ghuse-local <alias>` | Only set repo-local `user.name/email`, don't touch remotes |
| `ghuse-clear` | Unset the shell-scoped `GIT_*` env vars set by `ghuse` outside a repo |
| `ghpush <alias> [remote]` | One-shot push using a specific account's SSH key (via `GIT_SSH_COMMAND`) |
| `git_tag_add <tag>` | Create tag on `HEAD` and push to origin |
| `git_tag_delete <tag>` | Delete tag locally and on origin |
| `git_rebase_to_origin [branch]` | Rebase current branch onto `origin/<branch>` (default main) |
| `git_log_history <file>` | Show full commit history of a file including renames |
| `git_log_commiter_author` | `git log --pretty=format:"%h %ce %ae"` |
| `git-change-module-remote <submodule> <url>` | Rewrite a submodule's remote URL in-place |
| `gcim`, `gci` | Lingti-defined commit shortcuts _(gitauthor-aware)_ |
| `guns` | `git reset HEAD <file>` (unstage) |
| `gunc` | `git reset --soft HEAD~1` (uncommit, keep changes) |
| `gfap` | `git fetch --all --prune` |
| `gdf` | `git diff-tree --no-commit-id --name-only -r` |
| `gsst` | `git shortlog -sn` |
| `gnb <branch>` | `git checkout -b <branch>` (lingti alias) |
| `gdmb` | delete every local branch merged into main |
| `gpb` | push to a `build` branch pattern |

---

## Kubernetes

All rows below are **_lingti_** (`zsh/k8s.zsh`).

| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | kubectl shortcut |
| `kpg` | `kubectl get pods \| grep` | Grep pods |
| `ksg` | `kubectl get service \| grep` | Grep services |
| `k_get_pods_sort_by_time` | `kubectl get pods --sort-by=.metadata.creationTimestamp` | List pods by creation time |

### Functions

| Function | Description |
|----------|-------------|
| `set_k8s_context <ctx>` | Set kubernetes context (updates prompt) |
| `kexec -p <project> -n <ns>` | Open a shell in a pod |
| `kcp -p <project> -s <src> -d <dst>` | Copy a file from a pod |
| `klogs` | Tail logs |
| `ktail <instance> <file>` | Tail a file across every matching pod |
| `kdown <instance> <path> <dir>` | Download a file from every matching pod |
| `k_force_delete_pod <pod>` | Force delete a pod |
| `k_get_containers_of_pod <pod>` | List container names |
| `k_delete_evicted` | Delete evicted pods |
| `k_get_instance` | Print instance labels |

---

## Fasd (Quick Navigation)

Wired via `zsh/fasd.zsh` (not an oh-my-zsh plugin). Needs `fasd` on PATH.

| Alias | Command | Description |
|-------|---------|-------------|
| `a` | `fasd -a` | Any recent file/directory |
| `s` | `fasd -si` | Show / search / select |
| `d` | `fasd -d` | Recent directory |
| `f` | `fasd -f` | Recent file |
| `z` | `fasd_cd -d` | cd to recent directory |
| `zz` | `fasd_cd -d -i` | Interactive directory jump |
| `v` | `f -e vim` | Open recent file in vim |

---

## Docker

Only three convenience wrappers — all **_lingti_**. The oh-my-zsh `docker`
plugin is not loaded, so vanilla `d`, `dps`, `dstop`, etc. are not defined.

| Alias | Command |
|-------|---------|
| `docker-clean` | `docker container prune -f` |
| `docker_purge` | `docker stop $(docker ps -qa); docker rm $(docker ps -qa)` |
| `docker_restart_in_mac` | `killall Docker && open /Applications/Docker.app` |

---

## Ruby / Rails

All lingti-defined; may be removed in a future cleanup if Rails usage keeps dropping.

### Rails console & server

| Alias | Command |
|-------|---------|
| `c` | `rails c` |
| `ts` | `thin start` |
| `ms` | `mongrel_rails start` |

### Database

| Alias | Command |
|-------|---------|
| `rdm` | `rake db:migrate` |
| `rdmr` | `rake db:migrate:redo` |
| `dbm` | `spring rake db:migrate` |
| `dbmr` | `spring rake db:migrate:redo` |
| `dbmd` | `spring rake db:migrate:down` |
| `dbmu` | `spring rake db:migrate:up` |
| `dbtp` | `spring rake db:test:prepare` |

### Testing

| Alias | Command |
|-------|---------|
| `rs` | `rspec spec` |
| `sr` | `spring rspec` |
| `src` | `spring rails c` |
| `srgm` | `spring rails g migration` |
| `rails_test` | `rspec && rubocop` |

### Zeus

| Alias | Command |
|-------|---------|
| `zs` | `zeus server` |
| `zc` | `zeus console` |
| `zr` | `zeus rspec` |
| `zzz` | `rm .zeus.sock; pkill zeus; zeus start` |

---

## Node.js

| Alias | Command | Description |
|-------|---------|-------------|
| `cnpm` | `npm --registry=https://registry.npm.taobao.org` | NPM via China mirror _(lingti)_ |
| `yarn_sass` | `SASS_BINARY_SITE=... yarn` | Yarn with sass mirror _(lingti)_ |

### Function

| Function | Description |
|----------|-------------|
| `node_install_lts` | Install latest LTS Node.js and set as default _(lingti)_ |

---

## System Utilities

### File operations

| Alias | Command |
|-------|---------|
| `df` | `df -h` _(lingti)_ |
| `du` | `du -h -d 2` _(lingti)_ |
| `gz` | `tar -zcvf` _(lingti)_ |
| `less` | `less -r` _(lingti)_ |
| `tf` | `tail -f` _(lingti)_ |
| `l` | `less` _(lingti)_ |
| `ls_folder_size` | `du -sch .[!.]* * \| sort -h` _(lingti)_ |
| `find_large_files` | `sudo find / -xdev -type f -size +50M` _(lingti)_ |

### Process management

| Alias | Command |
|-------|---------|
| `ka9` | `killall -9` _(lingti)_ |
| `k9` | `kill -9` _(lingti)_ |
| `po <pid>` | print `/proc/<pid>` stdout + stderr _(lingti)_ |
| `top_by_memory` | `top -o %MEM` _(lingti)_ |

### Vim

| Alias | Command |
|-------|---------|
| `vim` | `nvim` _(lingti)_ |
| `vim_plain` | `vim -u NONE` _(lingti)_ |
| `ve` | `vim ~/.vimrc` _(lingti)_ |
| `ze` | `vim ~/.zshrc` _(lingti)_ |
| `:q` | `exit` _(lingti)_ |

### Network

| Alias | Command | Description |
|-------|---------|-------------|
| `ssh_by_password` | `ssh -o PreferredAuthentications=password …` | Force password SSH _(lingti)_ |
| `ssh_copy_id` | `ssh-copy-id -o PreferredAuthentications=password …` | Copy SSH key by password _(lingti)_ |
| `chrome_proxy` | `google-chrome --proxy-server='http://127.0.0.1:8118'` | Chrome through local proxy _(lingti)_ |

### Homebrew

| Alias | Command |
|-------|---------|
| `brewu` | `brew update && brew upgrade && brew cleanup && brew doctor` _(lingti)_ |

### Search

| Alias | Command |
|-------|---------|
| `agq` | `ag -Q` (literal mode) _(lingti)_ |

---

## Proxy

All functions below are **_lingti_** (`zsh/proxy.zsh`). See
[docs/tmux-keymaps.md](tmux-keymaps.md) for the matching tmux bindings
(`PRE C-p` = default 8668, `PRE @` = prompt, `PRE C-x` = off).

| Name | Command |
|------|---------|
| `proxy` | Interactive wrapper. `proxy` → prompt for port (prefilled 8668). `proxy 9999` → set directly. `proxy off` → unset. `proxy status` → show state |
| `set_proxy [port]` | Set `http_proxy` / `https_proxy` to `http://127.0.0.1:<port>` (default 8668) |
| `set_ss_proxy [port]` | Same but SOCKS5 (default 1080) |
| `unset_proxy` | Clear every proxy env var |

---

## Global Aliases

These expand mid-command. From `zsh/aliases.zsh`.

| Alias | Expands to | Example |
|-------|------------|---------|
| `G` | `\| grep` | `ls foo G bar` → `ls foo \| grep bar` |
| `L` | `\| less` | `history L` |
| `H` | `\| head` | `cat big.log H` |
| `S` | `\| sort` | `ls S` |
| `C` | `\| wc -l` | `ls C` |
| `N` | `> /dev/null` | `noisy_cmd N` |

---

## macOS Specific

From `zsh/aliases-darwin.zsh`.

| Alias | Command | Description |
|-------|---------|-------------|
| `showFiles` | `defaults write com.apple.finder AppleShowAllFiles YES && killall Finder` | Show hidden files in Finder |
| `hideFiles` | `defaults write com.apple.finder AppleShowAllFiles NO && killall Finder` | Hide hidden files in Finder |
| `list_identities` | `security find-identity -v -p codesigning` | List code signing identities |
| `chrome-cdp` | `open -a "Google Chrome" --args --remote-debugging-port=9222 --restore-last-session` | Chrome with CDP debugging enabled |
| `start` | `open` | Open file/URL (from oh-my-zsh `macos` plugin) |

---

## See Also

- [docs/vim-keymaps.md](vim-keymaps.md) — vim and SpaceVim keymaps
- [docs/tmux-keymaps.md](tmux-keymaps.md) — tmux keybindings
- [docs/bin-commands.md](bin-commands.md) — custom CLI utilities (`pdf2png`, `md2pdf`, `html2img`, `html2slides`, `ferry`, `chrome-mcp`, `chrome-cdp`, `ralphal`, `yolo`, …)
- Full oh-my-zsh git plugin: `~/.oh-my-zsh/plugins/git/git.plugin.zsh`
