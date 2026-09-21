# GitHub account switcher
#
# Accounts are loaded from ~/.lingti.local/github-accounts if it exists,
# otherwise falls back to _GITHUB_ACCOUNTS defined here (empty by default).
#
# Format — one entry per line in the local file, or add to the array below:
#   alias:username:email:~/.ssh/key_file:ssh_host_alias
#
# The ssh_host_alias must match a Host entry in ~/.ssh/config that points
# to github.com with the correct IdentityFile.
#
# Example ~/.lingti.local/github-accounts:
#   work:myworkuser:work@company.com:~/.ssh/github_work:github-work
#   personal:myuser:me@gmail.com:~/.ssh/github_personal:github.com
#
# Example ~/.ssh/config entry for a non-default account:
#   Host github-work
#       HostName github.com
#       User git
#       IdentityFile ~/.ssh/github_work
#       IdentitiesOnly yes

_GITHUB_ACCOUNTS=()

# Load accounts from local (private) config if present
_ghuse_local_config="$HOME/.lingti.local/github-accounts"
if [[ -f "$_ghuse_local_config" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue  # skip comments
    [[ -z "${line// /}" ]] && continue            # skip blank lines
    _GITHUB_ACCOUNTS+=("$line")
  done < "$_ghuse_local_config"
fi

ghuse() {
  # Flags
  local scope=auto  # auto (local if inside a repo, else refuse), or global
  local alias=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -g|--global) scope=global; shift ;;
      -l|--local)  scope=local;  shift ;;
      -h|--help)
        echo "Usage:"
        echo "  ghuse                  show current identity and available accounts"
        echo "  ghuse <alias>          inside a repo → set repo-local identity + rewrite remote URLs"
        echo "                         outside a repo → export GIT_* env vars for THIS shell"
        echo "                         (useful for cloning under a specific account; call"
        echo "                          ghuse-clear to drop them)"
        echo "  ghuse -g <alias>       set GLOBAL identity + global insteadOf (~/.gitconfig.user)"
        echo "  ghuse-clear            unset the shell-scoped GIT_* env vars"
        return 0 ;;
      *) alias="$1"; shift ;;
    esac
  done

  if [[ -z "$alias" ]]; then
    # Show current identity (prefer local when inside a repo)
    local name email origin
    if git rev-parse --git-dir &>/dev/null; then
      name=$(git config user.name 2>/dev/null)
      email=$(git config user.email 2>/dev/null)
      origin=$(git remote get-url origin 2>/dev/null)
      echo "Repo identity ($(git rev-parse --show-toplevel 2>/dev/null | sed "s|$HOME|~|")):"
      echo "  name:   ${name:-<inherits global>}"
      echo "  email:  ${email:-<inherits global>}"
      [[ -n "$origin" ]] && echo "  origin: $origin"
    else
      name=$(git config --global user.name 2>/dev/null)
      email=$(git config --global user.email 2>/dev/null)
      echo "Global identity (no repo here):"
      echo "  name:  ${name:-<not set>}"
      echo "  email: ${email:-<not set>}"
    fi

    if [[ ${#_GITHUB_ACCOUNTS[@]} -eq 0 ]]; then
      echo ""
      echo "No accounts configured. Add entries to ~/.lingti.local/github-accounts:"
      echo "  alias:username:email:~/.ssh/key_file:ssh_host_alias"
      return 0
    fi

    echo ""
    echo "Available accounts:"
    for entry in "${_GITHUB_ACCOUNTS[@]}"; do
      local a="${entry%%:*}"; local rest="${entry#*:}"
      local n="${rest%%:*}"; rest="${rest#*:}"
      local e="${rest%%:*}"; rest="${rest#*:}"
      local key="${rest%%:*}"; rest="${rest#*:}"
      local host="${rest%%:*}"
      local marker=""
      [[ "$n" == "$name" && "$e" == "$email" ]] && marker=" ◀ active"
      printf "  %-10s  %-20s  %-34s  key: %s  host: %s%s\n" "$a" "$n" "$e" "$key" "$host" "$marker"
    done
    return 0
  fi

  local matched=""
  for entry in "${_GITHUB_ACCOUNTS[@]}"; do
    [[ "${entry%%:*}" == "$alias" ]] && matched="$entry" && break
  done

  if [[ -z "$matched" ]]; then
    echo "Unknown account alias: $alias"
    [[ ${#_GITHUB_ACCOUNTS[@]} -gt 0 ]] && \
      echo "Available: ${(j:, :)${_GITHUB_ACCOUNTS[@]%%:*}}"
    return 1
  fi

  local rest="${matched#*:}"
  local name="${rest%%:*}"; rest="${rest#*:}"
  local email="${rest%%:*}"; rest="${rest#*:}"
  local key="${rest%%:*}"; rest="${rest#*:}"
  local host="${rest%%:*}"

  # Resolve scope: `auto` = local when inside a repo, else shell env vars
  # (persist until shell exits or `ghuse-clear`). Use -g to force global.
  if [[ "$scope" == "auto" ]]; then
    if git rev-parse --git-dir &>/dev/null; then
      scope=local
    else
      scope=env
    fi
  fi

  if [[ "$scope" == "env" ]]; then
    export GIT_AUTHOR_NAME="$name"
    export GIT_AUTHOR_EMAIL="$email"
    export GIT_COMMITTER_NAME="$name"
    export GIT_COMMITTER_EMAIL="$email"
    # GIT_SSH_COMMAND scopes key selection to this shell — any `git clone`,
    # `git fetch`, etc. runs authenticate as the target account regardless
    # of the URL host or global ~/.ssh/config default.
    export GIT_SSH_COMMAND="ssh -i ${~key} -o IdentitiesOnly=yes"
    echo "✓ Shell env → $name <$email>  (this shell only)"
    echo "  SSH key:   $key"
    echo "  SSH host:  git@${host}"
    echo ""
    echo "  Now: git clone git@github.com:<user>/<repo>.git"
    echo "  Then: cd <repo> && ghuse $alias    # make it stick locally in the clone"
    echo "  Or:  ghuse-clear                   # drop these env vars"
    return 0
  fi

  if [[ "$scope" == "global" ]]; then
    git config --global user.name  "$name"
    git config --global user.email "$email"
    local gitconfig_user="$HOME/.gitconfig.user"
    {
      echo "[url \"git@${host}:\"]"
      echo "    insteadOf = https://github.com/"
      echo "    insteadOf = git@github.com:"
      echo "[user]"
      echo "    name = $name"
      echo "    email = $email"
    } > "$gitconfig_user"
    echo "✓ Global identity → $name <$email>"
    echo "  SSH host:  git@${host}   key: $key"
    return 0
  fi

  # scope == local: touch only this repo
  git config user.name  "$name"
  git config user.email "$email"

  # Rewrite each remote's URL to point at the account's SSH host alias
  local remote url new_url changed=0
  for remote in $(git remote); do
    url="$(git remote get-url "$remote")"
    # Match https://github.com/... or git@github{,-anything}:... — normalise all to our host
    new_url="$(echo "$url" | sed -E "s#^(https://github\.com/|git@github[a-zA-Z0-9._-]*:)#git@${host}:#")"
    if [[ "$url" != "$new_url" ]]; then
      git remote set-url "$remote" "$new_url"
      echo "  $remote: $url → $new_url"
      changed=1
    fi
  done

  echo "✓ Repo identity → $name <$email>"
  echo "  SSH host:  git@${host}   key: $key"
  (( changed )) || echo "  (remotes already use git@${host}: — no rewrite needed)"
}

# Push current branch to the remote matching a given account alias.
# Usage: ghpush <alias> [remote]
#   ghpush yolo           — push to remote named 'yolojasonhuang' (alias as remote name)
#   ghpush yolo origin    — push to 'origin' using yolojason key
ghpush() {
  local alias="$1"
  if [[ -z "$alias" ]]; then
    echo "Usage: ghpush <account-alias> [remote]"
    return 1
  fi

  local matched=""
  for entry in "${_GITHUB_ACCOUNTS[@]}"; do
    [[ "${entry%%:*}" == "$alias" ]] && matched="$entry" && break
  done

  if [[ -z "$matched" ]]; then
    echo "Unknown account alias: $alias"
    return 1
  fi

  local rest="${matched#*:}"
  local _name="${rest%%:*}"; rest="${rest#*:}"
  local _email="${rest%%:*}"; rest="${rest#*:}"
  local key="${rest%%:*}"; rest="${rest#*:}"
  local host="${rest%%:*}"

  # Determine remote: explicit arg, else alias name, else origin
  local remote="${2:-$alias}"
  if ! git remote get-url "$remote" &>/dev/null; then
    remote="origin"
  fi

  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -z "$branch" ]]; then
    echo "Not on a branch."
    return 1
  fi

  echo "Pushing $branch → $remote (key: $key)"
  GIT_SSH_COMMAND="ssh -i ${~key} -o IdentitiesOnly=yes" git push "$remote" "$branch"
}

# Drop the shell-scoped git identity env vars set by `ghuse <alias>`
# outside a repo. Idempotent.
ghuse-clear() {
  unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_SSH_COMMAND
  echo "ghuse-clear: shell git env unset"
}

# Repo-local override: set git identity just for the current repo
ghuse-local() {
  local alias="$1"
  if [[ -z "$alias" ]]; then
    echo "Usage: ghuse-local <account-alias>"
    return 1
  fi

  local matched=""
  for entry in "${_GITHUB_ACCOUNTS[@]}"; do
    [[ "${entry%%:*}" == "$alias" ]] && matched="$entry" && break
  done

  if [[ -z "$matched" ]]; then
    echo "Unknown account alias: $alias"
    return 1
  fi

  local rest="${matched#*:}"
  local name="${rest%%:*}"; rest="${rest#*:}"
  local email="${rest%%:*}"

  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Not inside a git repository."
    return 1
  fi

  git config user.name  "$name"
  git config user.email "$email"
  echo "✓ Set local repo identity: $name <$email>"
}
