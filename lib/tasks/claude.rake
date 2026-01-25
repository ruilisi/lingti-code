# frozen_string_literal: true

desc 'Install Claude Code CLI'
task :install_claude_code do
  if command_exists?('claude')
    puts 'Claude Code is already installed'
    next
  end

  puts 'Installing Claude Code...'
  if macos?
    if command_exists?('brew')
      run 'brew install --cask claude-code'
    else
      run 'curl -fsSL https://claude.ai/install.sh | bash'
    end
  elsif linux?
    run 'curl -fsSL https://claude.ai/install.sh | bash'
  end
end

desc 'Install Claude CLI configuration'
task :install_claude do
  install_claude if want_to_install?('Claude CLI configuration')
end

def install_claude
  puts '======================================================'
  puts 'Setting up Claude configuration...'
  puts '======================================================'

  source_dir = File.join(ENV['PWD'], 'claude')
  target_dir = File.join(ENV['HOME'], '.claude')

  link_dir_files(source_dir, target_dir)
  puts
end
