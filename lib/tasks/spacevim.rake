# frozen_string_literal: true

task :install_spacevim do
  unless command_exists?('nvim')
    puts 'Installing neovim...'
    if macos?
      run 'brew install neovim'
    elsif linux?
      run 'sudo apt-get update && sudo apt-get install -y neovim'
    end
  end

  run 'git clone https://github.com/lingti/SpaceVim ~/.SpaceVim' unless file_exists?('~/.SpaceVim')
  run 'mkdir -p ~/.config && ln -nfs ~/.SpaceVim ~/.config/nvim'
end

task :update_spacevim do
  run %(
    cd ~/.SpaceVim
    git remote set-url origin https://github.com/lingti/SpaceVim.git
    git pull --rebase
  )
end

desc 'Prepare necessary components for spacevim/typescript'
task :prepare_spacevim_typescript do
  run %(
    pip install neovim
    npm install -g neovim typescript
  )
end
