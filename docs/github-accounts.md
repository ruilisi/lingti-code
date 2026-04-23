# GitHub Multi-Account Management

Manage multiple GitHub identities (personal, work, alt accounts) from the
command line — switching global identity, per-repo identity, and pushing with
the correct SSH key.

Provided by `~/.lingti/zsh/github-account.zsh`, loaded automatically on shell start.

---

## Setup

### 1. Generate an SSH key for each account

```zsh
ssh-keygen -t ed25519 -C "you@email.com" -f ~/.ssh/github_<alias>
```

### 2. Add each key to `~/.ssh/config`

For your **primary** account, the default `github.com` entry is enough:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_primary
    IdentitiesOnly yes
```

For **each additional** account, add a host alias:

```
Host github-<alias>
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_<alias>
    IdentitiesOnly yes
```

### 3. Add the public key to GitHub

```zsh
cat ~/.ssh/github_<alias>.pub
# paste at https://github.com/settings/keys
```

Verify authentication:

```zsh
ssh -T git@github.com          # Hi primaryuser!
ssh -T git@github-<alias>      # Hi altuser!
```

### 4. Register accounts in `~/.lingti.local/github-accounts`

This file is **private** — never committed. Create it:

```zsh
mkdir -p ~/.lingti.local
```

Add one line per account in this format:

```
alias:github_username:email:~/.ssh/key_file:ssh_host_alias
```

Example:

```
main:hophacker:me@gmail.com:~/.ssh/my_github:github.com
work:myworkuser:me@company.com:~/.ssh/github_work:github-work
```

- **alias** — short name you type in commands (e.g. `main`, `work`, `yolo`)
- **github_username** — your GitHub username
- **email** — commit author email
- **key_file** — path to the private key (use `~` — it's expanded at runtime)
- **ssh_host_alias** — the `Host` entry in `~/.ssh/config` (use `github.com` for the primary account, `github-<alias>` for alternates)

---

## Commands

### `ghuse` — show or switch global identity

```zsh
ghuse                 # show current git identity + list all configured accounts
ghuse <alias>         # switch global git identity and update ~/.gitconfig.user
```

**What switching does:**
- Sets `git config --global user.name` and `user.email`
- Rewrites `~/.gitconfig.user` with the matching SSH url rewrite:
  ```ini
  [url "git@github-work:"]
      insteadOf = https://github.com/
  [user]
      name = myworkuser
      email = me@company.com
  ```
  This ensures `git clone https://github.com/...` uses the correct key.

---

### `ghuse-local` — set identity for current repo only

```zsh
ghuse-local <alias>   # writes git config user.name/email into .git/config
```

Does not touch the global identity or `~/.gitconfig.user`. Useful when you
want one repo to commit as a different user without affecting everything else.

---

### `ghpush` — push with a specific account's SSH key

```zsh
ghpush <alias>              # push current branch to remote named <alias>
ghpush <alias> <remote>     # push current branch to <remote> using <alias> key
ghpush <alias> origin       # push to origin but force the <alias> SSH key
```

**Remote resolution logic:**

1. If `<remote>` is given explicitly, use it.
2. Otherwise try a remote whose name matches `<alias>`.
3. If no such remote exists, fall back to `origin`.

This means `ghpush yolo` pushes to a remote called `yolo` (if it exists),
**not** to `origin`. If you want to push a yolo-account repo that lives at
`origin`, use:

```zsh
ghpush yolo origin
```

**Examples:**

```zsh
# Repo has a remote named 'yolojasonhuang' pointing to yolojasonhuang/lsbot.git
ghpush yolo yolojasonhuang  # push to yolojasonhuang/lsbot.git with yolo key

# Repo's origin is already the yolo account's repo
ghpush yolo origin          # push to origin with yolo key

ghpush work                 # push to remote 'work' with work key
ghpush main                 # push to remote 'main' with primary key
```

`ghpush` uses `GIT_SSH_COMMAND` to inject the correct key without modifying
the remote URL, so it works regardless of which identity is currently active
globally.

---

## Full example: two accounts

**`~/.ssh/config`:**

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/my_github
    IdentitiesOnly yes

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_work
    IdentitiesOnly yes
```

**`~/.lingti.local/github-accounts`:**

```
personal:myuser:me@gmail.com:~/.ssh/my_github:github.com
work:myworkuser:me@company.com:~/.ssh/github_work:github-work
```

**Usage:**

```zsh
ghuse                   # show current identity
ghuse personal          # all new commits go as myuser <me@gmail.com>
ghuse work              # all new commits go as myworkuser <me@company.com>

ghuse-local work        # just this repo commits as work user

ghpush work             # push current branch → remote 'work' with work key
ghpush personal origin  # push current branch → origin with personal key
```

---

## Tips

- `~/.lingti.local/` should be in your global `.gitignore` — it holds private data.
- The `ssh_host_alias` for your primary account should be `github.com` (not a custom alias) so default `git clone` and `git push` just work without any extra config.
- After `ghuse <alias>`, existing remotes using `https://github.com/` are automatically rewritten to the correct SSH host via the `[url]` block in `~/.gitconfig.user`.
- `ghpush` is safe to use without switching global identity — it injects the key per-command via `GIT_SSH_COMMAND`.
