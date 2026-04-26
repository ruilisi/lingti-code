#!/bin/bash
set -e

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

install_pkg() {
  local pkg="$1" cmd="${2:-$1}"
  if ! command_exists "$cmd"; then
    info "Installing $pkg..."
    if [ "$(uname)" = "Darwin" ]; then
      if ! command_exists brew; then
        echo "Homebrew is required but not installed. Install it first:"
        echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
      fi
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
