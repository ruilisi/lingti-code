#!/bin/bash
set -e

# When invoked via `curl ... | bash`, the script body lives on stdin.
# Child processes (brew, gem, git) inherit that stdin and can swallow the
# rest of the script when they read input — causing the installer to exit
# early after the first heavy `brew install`. Re-exec from a temp file so
# stdin is detached from the script source.
if [ -z "$LINGTI_INSTALL_REEXEC" ] && [ ! -t 0 ]; then
  tmp=$(mktemp /tmp/lingti-install.XXXXXX)
  cat > "$tmp"
  trap "rm -f '$tmp'" EXIT
  LINGTI_INSTALL_REEXEC=1 bash "$tmp" "$@" < /dev/tty
  exit $?
fi

REPO="https://github.com/ruilisi/lingti-code.git"
INSTALL_DIR="$HOME/.lingti"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${BLUE}==>${RESET} ${BOLD}$1${RESET}"; }
success() { echo -e "${GREEN}==>${RESET} ${BOLD}$1${RESET}"; }

command_exists() { command -v "$1" &>/dev/null; }

install_homebrew() {
  info "Installing Homebrew (will prompt for sudo password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # brew isn't on PATH yet — locate it and source shellenv for this shell.
  local brew_bin
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      break
    fi
  done

  if ! command_exists brew; then
    echo "Homebrew install completed but brew is still not on PATH. Aborting."
    exit 1
  fi
}

install_pkg() {
  local pkg="$1" cmd="${2:-$1}"
  if ! command_exists "$cmd"; then
    info "Installing $pkg..."
    if [ "$(uname)" = "Darwin" ]; then
      command_exists brew || install_homebrew
      brew install "$pkg"
    else
      sudo apt install -y "$pkg"
    fi
  fi
}

# --- Main ---

if [ -d "$INSTALL_DIR" ] && [ -f "$INSTALL_DIR/Rakefile" ]; then
  echo "Lingti is already installed at $INSTALL_DIR"
  exit 0
elif [ -d "$INSTALL_DIR" ]; then
  echo "Found empty or incomplete $INSTALL_DIR, removing and reinstalling..."
  rm -rf "$INSTALL_DIR"
fi

info "Installing dependencies..."
install_pkg fontconfig fc-cache
for tool in zsh git tmux; do
  install_pkg "$tool"
done

if ! command_exists rake; then
  info "Installing rake..."
  gem install rake --no-document
fi

info "Cloning lingti-code..."
git clone --depth=1 "$REPO" "$INSTALL_DIR"
cd "$INSTALL_DIR"

[ "$1" = "ask" ] && export ASK="true"
rake install

success "Installation complete! Restarting shell..."
exec zsh
