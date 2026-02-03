#!/bin/bash

exists () {
  which $1 &> /dev/null; echo $?
}

install () {
  pkg=$1
  cmd=$2
  if [ -z "$2" ]; then
    cmd=$pkg
  fi
  if [ `exists $cmd` != "0" ]; then
    if [ "$(uname)" = "Darwin" ]; then
      brew install $pkg
    elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
      sudo apt install $pkg -y
    fi
  fi
}


install fontconfig fc-cache
tools=("zsh" "git" "rake" "tmux")
for tool in "${tools[@]}"; do
  install $tool
done


if [ ! -d "$HOME/.lingti" ]; then
    echo "Installing Lingti for the first time"
    git clone --depth=1 https://github.com/lingti/lingti-code.git "$HOME/.lingti"
    cd "$HOME/.lingti"
    [ "$1" = "ask" ] && export ASK="true"
    rake install
    exec zsh
else
    echo "Lingti is already installed"
fi
