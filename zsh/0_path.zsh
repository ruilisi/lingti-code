# path, the 0 in the filename causes this to load first

pathAppend() {
  # Only adds to the path if it's not already there
  if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
    PATH=$PATH:$1
  fi
}

pathPrepend() {
  # Adds to the front of PATH (overriding system commands of the same name)
  if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
    PATH=$1:$PATH
  fi
}

# Remove duplicate entries from PATH:
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')

# Prepend lingti bin so its shims (e.g. vim → nvim) win over system binaries
pathPrepend "$HOME/.lingti/bin"
pathPrepend "$HOME/.lingti/bin/lingti"
pathAppend "$HOME/bin"
pathAppend "$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"
if [[ `uname` == "Darwin" ]]; then
  pathAppend "/usr/local/opt/libpq/bin"
fi
