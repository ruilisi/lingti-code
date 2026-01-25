# frozen_string_literal: true

task :install_prezto do
  install_prezto if want_to_install?('zsh enhancements & prezto')
end

def install_prezto
  puts
  puts 'Installing Prezto (ZSH Enhancements)...'

  run %( ln -nfs "$HOME/.lingti/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto" )

  # The prezto runcoms are only going to be installed if zprezto has never been installed
  install_files(Dir.glob('zsh/prezto/runcoms/z*'), :symlink)

  puts
  puts "Overriding prezto ~/.zpreztorc with Lingti's zpreztorc to enable additional modules..."
  install_files(Dir.glob('zsh/prezto-override/z*'), :symlink)

  puts
  puts 'Creating directories for your customizations'
  run %( mkdir -p $HOME/.zsh.before )
  run %( mkdir -p $HOME/.zsh.after )
  run %( mkdir -p $HOME/.zsh.prompts )

  if (ENV['SHELL']).to_s.include? 'zsh'
    puts 'Zsh is already configured as your shell of choice. Restart your session to load the new settings'
  else
    puts 'Setting zsh as your default shell'
    if File.exist?('/usr/local/bin/zsh')
      if File.readlines('/private/etc/shells').grep('/usr/local/bin/zsh').empty?
        puts 'Adding zsh to standard shell list'
        run %( echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells )
      end
      run %( chsh -s /usr/local/bin/zsh )
    else
      run %( chsh -s /bin/zsh )
    end
  end
end
