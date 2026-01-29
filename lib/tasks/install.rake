# frozen_string_literal: true

INSTALL_STEPS = [
  { name: 'submodules',    desc: 'Git submodules' },
  { name: 'homebrew',      desc: 'Homebrew packages',    platform: :macos },
  { name: 'rvm_binstubs',  desc: 'RVM Bundler support' },
  { name: 'link_files',    desc: 'Symlink config files' },
  { name: 'prezto',        desc: 'ZSH/Prezto setup' },
  { name: 'spacevim',      desc: 'SpaceVim setup' },
  { name: 'asdf',          desc: 'ASDF version manager' },
  { name: 'claude_code',   desc: 'Claude Code CLI' },
  { name: 'claude',        desc: 'Claude CLI config' },
  { name: 'qshell',        desc: 'Qshell (Qiniu Cloud CLI)' },
  { name: 'fonts',         desc: 'Powerline fonts' },
  { name: 'term_theme',    desc: 'iTerm2 theme',         platform: :macos },
  { name: 'bundle_config', desc: 'Bundler config' },
].freeze

def run_step(name)
  case name
  when 'submodules'
    unless ENV['SKIP_SUBMODULES']
      run %( git submodule update --init --recursive )
      run %(
        cd $HOME/.lingti
        git submodule update --recursive
        git clean -df
      )
      puts
    end
  when 'homebrew'      then install_homebrew
  when 'rvm_binstubs'  then install_rvm_binstubs
  when 'link_files'    then Rake::Task['link_files'].execute
  when 'prezto'        then Rake::Task['install_prezto'].execute
  when 'spacevim'      then Rake::Task['install_spacevim'].execute
  when 'asdf'          then Rake::Task['install_asdf'].execute
  when 'claude_code'   then Rake::Task['install_claude_code'].execute
  when 'claude'        then Rake::Task['install_claude'].execute
  when 'qshell'        then Rake::Task['install_qshell'].execute
  when 'fonts'         then install_fonts
  when 'term_theme'    then install_term_theme
  when 'bundle_config' then run_bundle_config
  end
end

def run_install(from_beginning:)
  puts
  puts '======================================================'
  puts 'Welcome to Lingti Installation.'
  puts '======================================================'
  puts

  clear_install_progress if from_beginning
  completed = completed_steps

  if !from_beginning && completed.any?
    puts "Resuming install (#{completed.size}/#{INSTALL_STEPS.size} steps completed)"
    puts
  end

  INSTALL_STEPS.each do |step|
    name = step[:name]
    desc = step[:desc]

    if completed.include?(name)
      puts "Skipping (already completed): #{desc}"
      next
    end

    if step[:platform] && !send("#{step[:platform]}?")
      puts "Skipping (not on #{step[:platform]}): #{desc}"
      mark_step_completed(name)
      next
    end

    puts
    puts '======================================================'
    puts "Step: #{desc}"
    puts '======================================================'

    run_step(name)
    mark_step_completed(name)
  end

  success_msg('installed')
end

desc 'Hook our dotfiles into system-standard positions.'
task :install do
  run_install(from_beginning: true)
end

namespace :install do
  desc 'Resume installation from last completed step.'
  task :continue do
    run_install(from_beginning: false)
  end
end

task :link_files do
  install_files(Dir.glob('SpaceVim.d')) if want_to_install?('Spacevim config dir')
  install_files(Dir.glob('git/*')) if want_to_install?('git configs (color, aliases)')
  install_files(Dir.glob('irb/*')) if want_to_install?('irb/pry configs (more colorful)')
  install_files(Dir.glob('ruby/*')) if want_to_install?('rubygems config (faster/no docs)')
  install_files(Dir.glob('ctags/*')) if want_to_install?('ctags config (better js/ruby support)')
  install_files(Dir.glob('tmux/*')) if want_to_install?('tmux config')
  install_files(Dir.glob('vimify/*')) if want_to_install?('vimification of command line tools')
  run %(
    rm -rf ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  )
end

task :update do
  Rake::Task['vundle_migration'].execute if needs_migration_to_vundle?
  Rake::Task['install'].execute
end

task :sync do
  vundle_path = File.join('vim', 'bundle', 'vundle')
  unless File.exist?(vundle_path)
    run %(
      cd $HOME/.lingti
      git clone https://github.com/gmarik/vundle.git #{vundle_path}
    )
  end
end

task :submodule_init do
  run %( git submodule update --init --recursive ) unless ENV['SKIP_SUBMODULES']
end

desc 'Init and update submodules.'
task :submodules do
  unless ENV['SKIP_SUBMODULES']
    puts '======================================================'
    puts 'Downloading Lingti submodules...please wait'
    puts '======================================================'

    run %(
      cd $HOME/.lingti
      git submodule update --recursive
      git clean -df
    )
    puts
  end
end

task default: 'install'

def run_bundle_config
  return unless command_exists?('bundle')

  bundler_jobs = number_of_cores - 1
  puts '======================================================'
  puts 'Configuring Bundlers for parallel gem installation'
  puts '======================================================'
  run %( bundle config --global jobs #{bundler_jobs} )
  puts
end

def install_rvm_binstubs
  puts '======================================================'
  puts 'Installing RVM Bundler support. Never have to type'
  puts 'bundle exec again! Please use bundle --binstubs and RVM'
  puts "will automatically use those bins after cd'ing into dir."
  puts '======================================================'
  run %( chmod +x $rvm_path/hooks/after_cd_bundler )
  puts
end

def install_homebrew
  unless command_exists?('brew')
    puts '======================================================'
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts 'already installed, this will do nothing.'
    puts '======================================================'
    run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating Homebrew.'
  puts '======================================================'
  run %(brew update)
  puts
  puts
  puts '======================================================'
  puts 'Installing Homebrew packages...There may be some warnings.'
  puts '======================================================'
  run %(brew install zsh ctags git hub tmux reattach-to-user-namespace ripgrep ghi)
  run %(brew install macvim)
  puts
  puts
end

def install_fonts
  puts '======================================================'
  puts 'Installing patched fonts for Powerline/Lightline.'
  puts '======================================================'
  run %( cp -f $HOME/.lingti/fonts/* $HOME/Library/Fonts ) if macos?
  run %( mkdir -p ~/.fonts && cp ~/.lingti/fonts/* ~/.fonts && fc-cache -vf ~/.fonts ) if linux?
  puts
end

def needs_migration_to_vundle?
  File.exist? File.join('vim', 'bundle', 'tpope-vim-pathogen')
end
