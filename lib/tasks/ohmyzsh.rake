# frozen_string_literal: true

task :install_ohmyzsh do
  install_ohmyzsh if want_to_install?('zsh enhancements & oh-my-zsh')
end

def install_ohmyzsh
  puts
  puts 'Installing oh-my-zsh...'

  # Probe the actual entry script, not just the directory — a half-failed
  # install leaves ~/.oh-my-zsh/ around without oh-my-zsh.sh and would
  # otherwise be silently skipped on re-run.
  omz_dir = File.expand_path('~/.oh-my-zsh')
  omz_entry = File.join(omz_dir, 'oh-my-zsh.sh')
  unless File.exist?(omz_entry)
    if File.exist?(omz_dir)
      puts "Removing incomplete #{omz_dir} (missing oh-my-zsh.sh)"
      run %( rm -rf "#{omz_dir}" )
    end
    # KEEP_ZSHRC=yes prevents the OMZ installer from overwriting ~/.zshrc,
    # which is symlinked to zsh/zshrc by link_files (loads all zsh/*.zsh).
    run %{ KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended }
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

  set_default_shell_to_zsh
end

desc 'Set zsh as the default login shell (idempotent; safe to re-run).'
task :set_default_shell do
  set_default_shell_to_zsh
end

# Pick the best zsh on PATH, register it in /etc/shells, run chsh.
# Reads the *login* shell via dscl/getent — not ENV['SHELL'], which lies
# when invoked from inside a zsh subshell during install.
def set_default_shell_to_zsh
  zsh_path = %w[/opt/homebrew/bin/zsh /usr/local/bin/zsh /bin/zsh].find { |p| File.executable?(p) }
  unless zsh_path
    puts 'No zsh binary found. Install one first (e.g. `brew install zsh`).'
    return
  end

  current_login_shell =
    if macos?
      `dscl . -read ~/ UserShell 2>/dev/null`.split.last
    else
      `getent passwd "$USER" 2>/dev/null`.chomp.split(':').last
    end

  if current_login_shell == zsh_path
    puts "Login shell is already #{zsh_path}."
    return
  end

  shells_file = '/etc/shells'
  unless File.read(shells_file).split("\n").map(&:strip).include?(zsh_path)
    puts "Adding #{zsh_path} to #{shells_file} (sudo required)"
    run %( echo "#{zsh_path}" | sudo tee -a #{shells_file} > /dev/null )
  end

  puts "Setting login shell to #{zsh_path} (chsh may prompt for password)"
  run %( chsh -s "#{zsh_path}" )
  puts 'Done. Log out and back in (or open a new terminal tab) for it to take effect.'
end
