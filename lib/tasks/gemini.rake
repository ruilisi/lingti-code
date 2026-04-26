# frozen_string_literal: true

desc 'Install Gemini CLI'
task :install_gemini do
  if command_exists?('gemini')
    puts 'Gemini CLI is already installed'
    next
  end

  # Ensure npm is available, installing nvm/node if needed
  unless command_exists?('npm')
    nvm_sh = File.expand_path('~/.nvm/nvm.sh')

    unless File.exist?(nvm_sh)
      puts 'nvm (Node version manager) is not installed.'
      print 'Install nvm and Node.js? [y/n] '
      answer = STDIN.gets.to_s.chomp
      unless answer == 'y'
        puts 'Skipping Gemini CLI install (npm required).'
        next
      end

      puts 'Installing nvm...'
      run %(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash)
    end

    puts 'Installing Node.js via nvm...'
    run %(bash -c 'source #{nvm_sh} && nvm install --lts && nvm use --lts')
    # Re-check after install
    unless command_exists?('npm')
      puts 'npm still not found after nvm install. Please open a new shell and re-run.'
      next
    end
  end

  puts 'Installing Gemini CLI...'
  run 'npm install -g @google/gemini-cli'
end
