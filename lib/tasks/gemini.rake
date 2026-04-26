# frozen_string_literal: true

desc 'Install Gemini CLI'
task :install_gemini do
  if command_exists?('gemini')
    puts 'Gemini CLI is already installed'
    next
  end

  puts 'Installing Gemini CLI...'
  if command_exists?('npm')
    run 'npm install -g @google/gemini-cli'
  else
    puts 'npm is required to install Gemini CLI. Install Node.js first: https://nodejs.org'
  end
end
