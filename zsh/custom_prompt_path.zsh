#Load themes from lingti and from user's custom prompts (themes) in ~/.zsh.prompts
autoload promptinit
fpath=($HOME/.lingti/zsh/prezto-themes $HOME/.zsh.prompts $fpath)
promptinit
