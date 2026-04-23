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
  local alias="$1"

  if [[ -z "$alias" ]]; then
    # Show current identity
    local name email
    name=$(git config --global user.name 2>/dev/null)
    email=$(git config --global user.email 2>/dev/null)
    echo "Current GitHub account:"
    echo "  name:  ${name:-<not set>}"
    echo "  email: ${email:-<not set>}"

    if [[ ${#_GITHUB_ACCOUNTS[@]} -eq 0 ]]; then
      echo ""
      echo "No accounts configured."
      echo "Add entries to ~/.lingti.local/github-accounts:"
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

  git config --global user.name  "$name"
  git config --global user.email "$email"

  # Update ~/.gitconfig.user — url rewrite + user identity
  local gitconfig_user="$HOME/.gitconfig.user"
  {
    echo "[url \"git@${host}:\"]"
    echo "    insteadOf = https://github.com/"
    echo "[user]"
    echo "    name = $name"
    echo "    email = $email"
  } > "$gitconfig_user"

  echo "✓ Switched to GitHub account: $name <$email>"
  echo "  SSH key:  $key"
  echo "  SSH host: git@${host}"
  echo ""
  echo "  Add this public key to https://github.com/settings/keys if not already done:"
  echo "  $(cat ${~key}.pub 2>/dev/null || echo "(key file not found: ${key}.pub)")"
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
