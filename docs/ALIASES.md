# Shell Aliases Reference

This document provides a comprehensive reference for all shell aliases available in the Lingti dotfiles.

## Table of Contents

- [Prompt Toggle](#prompt-toggle)
- [Lingti Management](#lingti-management)
- [Navigation](#navigation)
- [File Listing](#file-listing)
- [Git](#git)
- [Kubernetes](#kubernetes)
- [Fasd (Quick Navigation)](#fasd-quick-navigation)
- [Docker](#docker)
- [Ruby / Rails](#ruby--rails)
- [Node.js](#nodejs)
- [System Utilities](#system-utilities)
- [Global Aliases](#global-aliases)
- [macOS Specific](#macos-specific)

---

## Prompt Toggle

| Alias | Command | Description |
|-------|---------|-------------|
| `show_username` | `SHOW_USERNAME=1; prompt_skwp_setup` | Show username in prompt |
| `hide_username` | `SHOW_USERNAME=0; prompt_skwp_setup` | Hide username (default) |
| `show_kcontext` | `SHOW_KCONTEXT=1; prompt_skwp_setup` | Show kubernetes context |
| `hide_kcontext` | `SHOW_KCONTEXT=0; prompt_skwp_setup` | Hide kubernetes context (default) |
| `disable_git_info` | `DISABLE_GIT_INFO=1` | Disable git info in prompt |
| `enable_git_info` | `DISABLE_GIT_INFO=0` | Enable git info in prompt |

---

## Lingti Management

| Alias | Command | Description |
|-------|---------|-------------|
| `lav` | `lingti vim-add-plugin` | Add vim plugin |
| `ldv` | `lingti vim-delete-plugin` | Delete vim plugin |
| `llv` | `lingti vim-list-plugin` | List vim plugins |
| `lup` | `lingti update-plugins` | Update all plugins |
| `lip` | `lingti init-plugins` | Initialize plugins |
| `ae` | `vim $lingti/zsh/aliases.zsh` | Edit aliases file |
| `edit_alias` | `vim aliases.zsh functions.zsh -p` | Edit aliases and functions |
| `gar` | `killall -HUP -u "$USER" zsh` | Global alias reload |
| `ss` | `source ~/.zshrc` | Source zshrc |

---

## Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `cdb` | `cd -` | Go to previous directory |
| `cls` | `clear; ls` | Clear screen and list files |
| `cl` | `clear` | Clear screen |
| `...` | `../..` | Go up 2 directories |
| `....` | `../../..` | Go up 3 directories |
| `.....` | `../../../..` | Go up 4 directories |

---

## File Listing

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -alGh` (macOS) / `ls -alh --color=auto` (Linux) | Long list with human sizes |
| `ls` | `ls -Gh` (macOS) / `ls --color=auto` (Linux) | Colored list |
| `lsg` | `ll \| grep` | List and grep |
| `lh` | `ls -alt \| head` | Last modified files |
| `lp` | `ls --hide="*.pyc"` | List hiding pyc files |

---

## Git

### Status & Info

| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status` | Git status |
| `gl` | `git l` | Git log (pretty) |
| `gsh` / `gshow` | `git show` | Show commit |
| `grv` | `git remote -v` | List remotes |
| `gb` | `git b` | List branches |
| `grb` | `git recent-branches` | Recent branches |

### Staging & Committing

| Alias | Command | Description |
|-------|---------|-------------|
| `ga` | `git add -A` | Add all files |
| `gap` | `git add -p` | Add interactively |
| `gci` | `git ci` | Commit |
| `gcm` / `gcim` | `git ci -m` | Commit with message |
| `gam` | `git amend --reset-author` | Amend commit |
| `guns` | `git unstage` | Unstage files |
| `gunc` | `git uncommit` | Uncommit |

### Diff

| Alias | Command | Description |
|-------|---------|-------------|
| `gd` | `git diff` | Show diff |
| `gdc` | `git diff --cached -w` | Diff staged changes |
| `gds` | `git diff --staged -w` | Diff staged changes |
| `gdf` | `git diff-tree --no-commit-id --name-only -r` | Show changed files |

### Branches & Checkout

| Alias | Command | Description |
|-------|---------|-------------|
| `co` | `git co` | Checkout |
| `gnb` | `git nb` | New branch (checkout -b) |
| `gdmb` | `git branch --merged \| grep -v "\*" \| xargs -n 1 git branch -d` | Delete merged branches |

### Fetch & Pull

| Alias | Command | Description |
|-------|---------|-------------|
| `gf` | `git fetch` | Fetch |
| `gfp` | `git fetch --prune` | Fetch with prune |
| `gfa` | `git fetch --all` | Fetch all remotes |
| `gfap` | `git fetch --all --prune` | Fetch all with prune |
| `gpl` | `git pull` | Pull |
| `gplr` | `git pull --rebase` | Pull with rebase |

### Push

| Alias | Command | Description |
|-------|---------|-------------|
| `gps` | `git push` | Push |
| `gpsh` | `git push -u origin HEAD` | Push and set upstream |
| `gpo` | `git push origin` | Push to origin |
| `gpb` | `git push origin :build` | Push to build branch |

### Stash

| Alias | Command | Description |
|-------|---------|-------------|
| `gst` / `gstsh` | `git stash` | Stash changes |
| `gsp` | `git stash pop` | Pop stash |

### Rebase & Merge

| Alias | Command | Description |
|-------|---------|-------------|
| `gr` | `git rebase` | Rebase |
| `gra` | `git rebase --abort` | Abort rebase |
| `ggrc` | `git rebase --continue` | Continue rebase |
| `gbi` | `git rebase --interactive` | Interactive rebase |
| `gm` | `git merge` | Merge |
| `gms` | `git merge --squash` | Squash merge |

### Reset & Clean

| Alias | Command | Description |
|-------|---------|-------------|
| `grs` | `git reset` | Reset |
| `grsh` | `git reset --hard` | Hard reset |
| `gcln` | `git clean` | Clean |
| `gclndf` | `git clean -df` | Clean directories and files |
| `gclndfx` | `git clean -dfx` | Clean including ignored |

### Submodules & Tags

| Alias | Command | Description |
|-------|---------|-------------|
| `gsm` | `git submodule` | Submodule command |
| `gsmi` | `git submodule init` | Init submodules |
| `gsmu` | `git submodule update` | Update submodules |
| `gt` | `git t` | Tag |

### Remote

| Alias | Command | Description |
|-------|---------|-------------|
| `grr` | `git remote rm` | Remove remote |
| `grad` | `git remote add` | Add remote |

### Functions

| Function | Description |
|----------|-------------|
| `gfr_key <key_path>` | Git pull --rebase with specified SSH key |
| `gpc_key <key_path>` | Git push current branch with specified SSH key |

---

## Kubernetes

| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | Kubectl shortcut |
| `kpg` | `kubectl get pods \| grep` | Get pods and grep |
| `ksg` | `kubectl get service \| grep` | Get services and grep |
| `k_get_pods_sort_by_time` | `k get pods --sort-by=.metadata.creationTimestamp` | List pods by creation time |

### Functions

| Function | Description |
|----------|-------------|
| `set_k8s_context <context>` | Set kubernetes context (updates prompt) |
| `kexec -p <project> -n <namespace>` | Execute shell in pod |
| `kcp -p <project> -s <src> -d <dst>` | Copy from pod |
| `klogs` | Tail logs |
| `k_force_delete_pod <pod>` | Force delete pod |
| `k_get_containers_of_pod <pod>` | Get container names |
| `k_delete_evicted` | Delete evicted pods |
| `k_get_instance` | Get instance labels |

---

## Fasd (Quick Navigation)

| Alias | Command | Description |
|-------|---------|-------------|
| `a` | `fasd -a` | Any recent file/directory |
| `s` | `fasd -si` | Show/search/select |
| `d` | `fasd -d` | Recent directory |
| `f` | `fasd -f` | Recent file |
| `z` | `fasd_cd -d` | cd to recent directory |
| `zz` | `fasd_cd -d -i` | Interactive directory jump |
| `v` | `f -e vim` | Open recent file in vim |

---

## Docker

| Alias | Command | Description |
|-------|---------|-------------|
| `docker-clean` | `docker container prune -f` | Remove stopped containers |
| `docker_purge` | `docker stop $(docker ps -qa); docker rm $(docker ps -qa)` | Stop and remove all containers |
| `docker_restart_in_mac` | `killall Docker && open /Applications/Docker.app` | Restart Docker on macOS |

---

## Ruby / Rails

### Rails Console & Server

| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `rails c` | Rails console (Rails 3+) |
| `ts` | `thin start` | Start thin server |
| `ms` | `mongrel_rails start` | Start mongrel server |

### Database

| Alias | Command | Description |
|-------|---------|-------------|
| `rdm` | `rake db:migrate` | Run migrations |
| `rdmr` | `rake db:migrate:redo` | Redo last migration |
| `dbm` | `spring rake db:migrate` | Migrate with spring |
| `dbmr` | `spring rake db:migrate:redo` | Redo with spring |
| `dbmd` | `spring rake db:migrate:down` | Migrate down |
| `dbmu` | `spring rake db:migrate:up` | Migrate up |
| `dbtp` | `spring rake db:test:prepare` | Prepare test db |

### Testing

| Alias | Command | Description |
|-------|---------|-------------|
| `rs` | `rspec spec` | Run rspec |
| `sr` | `spring rspec` | Run rspec with spring |
| `src` | `spring rails c` | Spring rails console |
| `srgm` | `spring rails g migration` | Generate migration |
| `rails_test` | `rspec && rubocop` | Run tests and linter |

### Zeus

| Alias | Command | Description |
|-------|---------|-------------|
| `zs` | `zeus server` | Zeus server |
| `zc` | `zeus console` | Zeus console |
| `zr` | `zeus rspec` | Zeus rspec |
| `zzz` | `rm .zeus.sock; pkill zeus; zeus start` | Restart zeus |

---

## Node.js

| Alias | Command | Description |
|-------|---------|-------------|
| `cnpm` | `npm --registry=https://registry.npm.taobao.org` | NPM with China mirror |
| `yarn_sass` | `SASS_BINARY_SITE=... yarn` | Yarn with sass mirror |

### Function

| Function | Description |
|----------|-------------|
| `node_install_lts` | Install latest LTS Node.js and set as default |

---

## System Utilities

### File Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `df` | `df -h` | Disk free (human readable) |
| `du` | `du -h -d 2` | Disk usage (2 levels deep) |
| `gz` | `tar -zcvf` | Create gzip archive |
| `less` | `less -r` | Less with raw control chars |
| `tf` | `tail -f` | Tail follow |
| `l` | `less` | Less shortcut |
| `ls_folder_size` | `du -sch .[!.]* * \| sort -h` | List folder sizes |
| `find_large_files` | `sudo find / -xdev -type f -size +50M` | Find files > 50MB |

### Process Management

| Alias | Command | Description |
|-------|---------|-------------|
| `ka9` | `killall -9` | Kill all by name |
| `k9` | `kill -9` | Kill by PID |
| `top_by_memory` | `top -o %MEM` | Top sorted by memory |

### Vim

| Alias | Command | Description |
|-------|---------|-------------|
| `vim` | `nvim` | Use neovim |
| `vim_plain` | `vim -u NONE` | Vim without config |
| `ve` | `vim ~/.vimrc` | Edit vimrc |
| `ze` | `vim ~/.zshrc` | Edit zshrc |
| `:q` | `exit` | Exit shell (vim style) |

### Network

| Alias | Command | Description |
|-------|---------|-------------|
| `ssh_by_password` | `ssh -o PreferredAuthentications=password ...` | SSH forcing password |
| `ssh_copy_id` | `ssh-copy-id -o PreferredAuthentications=password ...` | Copy SSH key with password |
| `chrome_proxy` | `google-chrome --proxy-server='http://127.0.0.1:8118'` | Chrome with proxy |

### Homebrew

| Alias | Command | Description |
|-------|---------|-------------|
| `brewu` | `brew update && brew upgrade && brew cleanup && brew doctor` | Full brew update |

### Search

| Alias | Command | Description |
|-------|---------|-------------|
| `agq` | `ag -Q` | ag with literal search |

---

## Global Aliases

These can be used anywhere in a command line:

| Alias | Expands To | Description |
|-------|------------|-------------|
| `G` | `\| grep` | Pipe to grep |
| `L` | `\| less` | Pipe to less |
| `H` | `\| head` | Pipe to head |
| `S` | `\| sort` | Pipe to sort |
| `C` | `\| wc -l` | Count lines |
| `N` | `\| /dev/null` | Redirect to null |

Example: `ls foo G something` expands to `ls foo | grep something`

---

## macOS Specific

| Alias | Command | Description |
|-------|---------|-------------|
| `showFiles` | `defaults write ... AppleShowAllFiles YES` | Show hidden files in Finder |
| `hideFiles` | `defaults write ... AppleShowAllFiles NO` | Hide hidden files in Finder |
| `list_identities` | `security find-identity -v -p codesigning` | List code signing identities |
| `start` | `open` | Open file/URL |

---

## See Also

- [Vim Keymaps](../claude/CLAUDE.md#vim-keymaps) - Vim keyboard shortcuts
- [SpaceVim Documentation](https://spacevim.org/documentation/) - SpaceVim reference
