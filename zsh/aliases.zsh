# Aliases in this file are bash and zsh compatible

# Don't change. The following determines where Lingti is installed.
lingti=$HOME/.lingti
lingti_zsh=$lingti/zsh

# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

# Lingti support
alias lav='lingti vim-add-plugin'
alias ldv='lingti vim-delete-plugin'
alias llv='lingti vim-list-plugin'
alias lup='lingti update-plugins'
alias lip='lingti init-plugins'

# PS
psm() {
  ps aux | awk 'NR>1 {$5=int($5/1024)"M";$6=int($6/1024)"M";}{ print;}'
}
# Moving around
alias cdb='cd -'
alias cls='clear;ls'

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

if [[ $platform == 'linux' ]]; then
  alias ll='ls -alh --color=auto'
  alias ls='ls --color=auto'
elif [[ $platform == 'darwin' ]]; then
  alias ll='ls -alGh'
  alias ls='ls -Gh'
fi

# show me files matching "ls grep"
alias lsg='ll | grep'
alias lp='ls --hide="*.pyc"'

# Alias Editing
TRAPHUP() {
  source $lingti/zsh/aliases.zsh
}

alias ae='vim $lingti/zsh/aliases.zsh' #alias edit
alias gar="killall -HUP -u \"$USER\" zsh"  #global alias reload

# vim using
mvim --version > /dev/null 2>&1
MACVIM_INSTALLED=$?
if [ $MACVIM_INSTALLED -eq 0 ]; then
  alias vim="mvim -v"
fi

# mimic vim functions
alias :q='exit'

# vimrc editing
alias ve='vim ~/.vimrc'

# zsh profile editing
alias ze='vim ~/.zshrc'

# Git Aliases (most provided by omz-git plugin in ~/.zsh.after/)
# Custom aliases not covered by oh-my-zsh git plugin:
unalias gs
alias gcim='git ci -m'
alias gci='git ci'
alias guns='git unstage'
alias gunc='git uncommit'
alias gfap='git fetch --all --prune'
alias gdf="git diff-tree --no-commit-id --name-only -r"
alias gsst='git show --shortstat --format=""' # show only total lines changed
alias gnb='git nb' # new branch aka checkout -b
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gpb='git push origin "$(git-branch-current 2> /dev/null):build"'
git_rebase_to_origin() {
  BRANCH=${1:-master}
  DIRTY=false
  git fetch origin
  [[ -n $(git status -s) ]] && DIRTY=true
  $DIRTY && echo "Git is dirty"
  $DIRTY && (git add .; git stash)
  git rebase origin/$BRANCH
  $DIRTY && (git stash pop; git reset HEAD)
}
git_rm_tag_of_remote() {
  TAG=$1
  REMOTE=${2:-origin}
  git tag -d $TAG
  git push --delete $REMOTE $TAG
}
git_log_history='git log -p --'

# Common shell functions
alias less='less -r'
alias tf='tail -f'
alias l='less'
alias lh='ls -alt | head' # see the last modified files
alias screen='TERM=screen screen'
alias cl='clear'

# Zippin
alias gz='tar -zcvf'

# Ruby
alias c='rails c' # Rails 3
alias co='script/console' # Rails 2
alias cod='script/console --debugger'

#If you want your thin to listen on a port for local VM development
#export VM_IP=10.0.0.1 <-- your vm ip
alias ts='thin start -a ${VM_IP:-127.0.0.1}'
alias ms='mongrel_rails start'
alias tfdl='tail -f log/development.log'
alias tftl='tail -f log/test.log'

alias ka9='killall -9'
alias k9='kill -9'

# Gem install
alias sgi='sudo gem install --no-ri --no-rdoc'

# TODOS
# This uses NValt (NotationalVelocity alt fork) - http://brettterpstra.com/project/nvalt/
# to find the note called 'todo'
alias todo='open nvalt://find/todo'

# Forward port 80 to 3000
alias portforward='sudo ipfw add 1000 forward 127.0.0.1,3000 ip from any to any 80 in'

alias rdm='rake db:migrate'
alias rdmr='rake db:migrate:redo'

# Zeus
alias zs='zeus server'
alias zc='zeus console'
alias zr='zeus rspec'
alias zrc='zeus rails c'
alias zrs='zeus rails s'
alias zrdbm='zeus rake db:migrate'
alias zrdbtp='zeus rake db:test:prepare'
alias zzz='rm .zeus.sock; pkill zeus; zeus start'

# Rspec
alias rs='rspec spec'
alias sr='spring rspec'
alias src='spring rails c'
alias srgm='spring rails g migration'
alias srdm='spring rake db:migrate'
alias srdt='spring rake db:migrate'
alias srdmt='spring rake db:migrate db:test:prepare'


# Sprintly - https://github.com/nextbigsoundinc/Sprintly-GitHub
alias sp='sprintly'
# spb = sprintly branch - create a branch automatically based on the bug you're working on
alias spb="git checkout -b \`sp | tail -2 | grep '#' | sed 's/^ //' | sed 's/[^A-Za-z0-9 ]//g' | sed 's/ /-/g' | cut -d"-" -f1,2,3,4,5\`"

# hub pull-request (use gh pr create instead)
# alias hpr='hub pull-request'

# Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias dbtp='spring rake db:test:prepare'
alias dbm='spring rake db:migrate'
alias dbmr='spring rake db:migrate:redo'
alias dbmd='spring rake db:migrate:down'
alias dbmu='spring rake db:migrate:up'

# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'


# emacs
alias emacs="env LC_CTYPE=zh_CN.UTF-8 emacs"

# rails
alias rails_setup='rails db:reset; rails db:seed RAILS_ENV=test'
alias rails_test='rspec && rubocop'

alias start_dropbox='~/.dropbox-dist/dropboxd'
alias unzip_CN="unzip -O GB18030"
alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"

# Install latest LTS Node.js and set as default
node_install_lts() {
  nvm install --lts && nvm alias default "$(nvm version)" && nvm use default && echo "$(nvm version)" >| ~/.nvmrc
}
case "$OSTYPE" in
   cygwin*)
      alias open="cmd /c start"
      ;;
   linux*)
      alias start="xdg-open"
      alias open="xdg-open"
      ;;
   darwin*)
      alias start="open"
      ;;
esac
alias ssh_by_password='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias ssh_copy_id='ssh-copy-id -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias chrome_proxy="google-chrome --proxy-server='http://127.0.0.1:8118'"
alias ls_folder_size="du -sch .[!.]* * | sort -h"
alias top_by_memory="top -o %MEM"
alias ror_ctags="ctags -R --languages=ruby --exclude=.git --exclude=log . \$(bundle list --paths)"
alias find_large_files="sudo find / -xdev -type f -size +50M"
alias vim_plain="vim -u NONE"
alias edit_alias="vim $lingti_zsh/aliases.zsh $lingti_zsh/functions.zsh -p"
alias yarn_sass="SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass/ yarn"
alias vim="nvim"

## docker
alias docker_purge='docker stop $(docker ps -qa);docker rm $(docker ps -qa)'
alias docker_restart_in_mac='killall Docker && open /Applications/Docker.app'

## source files
alias ss="source ~/.zshrc"
alias delete_all_binaries="find . -type f -perm -u+x -not -path './.git/*' | xargs rm"

## grep && ag
alias agq="ag -Q"

## git with specified SSH key
# gfr_key <key_path>: git pull --rebase with specified SSH key
gfr_key() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: gfr_key <key_path>"
    return 1
  fi
  if [[ ! -f "$key" ]]; then
    echo "SSH key not found: $key"
    return 1
  fi
  shift
  GIT_SSH_COMMAND="ssh -i $key -o IdentitiesOnly=yes" git pull --rebase "$@"
}

# gpc_key <key_path>: git push current branch with specified SSH key
gpc_key() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: gpc_key <key_path>"
    return 1
  fi
  if [[ ! -f "$key" ]]; then
    echo "SSH key not found: $key"
    return 1
  fi
  shift
  GIT_SSH_COMMAND="ssh -i $key -o IdentitiesOnly=yes" git push --set-upstream origin "$(git-branch-current 2>/dev/null)" "$@"
}

# Claude Code
alias claude-yolo='claude --dangerously-skip-permissions'
