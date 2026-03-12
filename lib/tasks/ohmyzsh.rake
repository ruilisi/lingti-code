# frozen_string_literal: true

task :install_ohmyzsh do
  install_ohmyzsh if want_to_install?('zsh enhancements & oh-my-zsh')
end

def install_ohmyzsh
  puts
  puts 'Installing oh-my-zsh...'

  unless File.exist?(File.expand_path('~/.oh-my-zsh'))
    run %{ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended }
  end

  zsh_custom = File.expand_path('~/.oh-my-zsh/custom/plugins')
  {
    'zsh-syntax-highlighting' => 'https://github.com/zsh-users/zsh-syntax-highlighting',
    'zsh-history-substring-search' => 'https://github.com/zsh-users/zsh-history-substring-search'
  }.each do |name, url|
    unless File.exist?("#{zsh_custom}/#{name}")
      run %{ git clone #{url} #{zsh_custom}/#{name} }
    end
  end

  %w[~/.zsh.before ~/.zsh.after ~/.zsh.prompts].each { |d| FileUtils.mkdir_p(File.expand_path(d)) }

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
