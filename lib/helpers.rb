# frozen_string_literal: true

require 'fileutils'

module Lingti
  module Helpers
    # Platform detection
    def macos?
      RUBY_PLATFORM.downcase.include?('darwin')
    end

    def linux?
      RUBY_PLATFORM.downcase.include?('linux')
    end

    def command_exists?(cmd)
      system("which #{cmd} > /dev/null 2>&1")
    end

    def file_exists?(path)
      File.exist?(File.expand_path(path))
    end

    # Command execution
    def run(cmd)
      puts "[Running] #{cmd}"
      system(cmd) unless ENV['DEBUG']
    end

    def number_of_cores
      if macos?
        `sysctl -n hw.ncpu`.to_i
      else
        `nproc`.to_i
      end
    end

    # User interaction
    def want_to_install?(section)
      if ENV['ASK'] == 'true'
        puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
        STDIN.gets.chomp == 'y'
      else
        true
      end
    end

    def ask(message, values)
      puts message
      while true
        values.each_with_index { |val, idx| puts " #{idx + 1}. #{val}" }
        selection = STDIN.gets.chomp
        if (begin
          Float(selection).nil?
        rescue StandardError
          true
        end) || selection.to_i < 0 || selection.to_i > values.size + 1
          puts "ERROR: Invalid selection.\n\n"
        else
          break
        end
      end
      selection = selection.to_i - 1
      values[selection]
    end

    # File linking utilities
    def link_dir_files(source_dir, target_dir)
      unless File.exist?(target_dir)
        puts "Creating directory: #{target_dir}"
        FileUtils.mkdir_p(target_dir)
      end

      Dir.glob(File.join(source_dir, '*')).each do |source|
        file = File.basename(source)
        target = File.join(target_dir, file)

        if File.directory?(source)
          if File.symlink?(target) && File.readlink(target) == source
            puts "Skipping (already linked): #{target}"
          elsif File.exist?(target) && !File.symlink?(target)
            puts "Skipping (directory exists): #{target}"
          else
            puts "Linking directory: #{source} -> #{target}"
            FileUtils.rm_f(target)
            run %( ln -nfs "#{source}" "#{target}" )
          end
        elsif !File.exist?(target)
          puts "Linking: #{source} -> #{target}"
          run %( ln -nfs "#{source}" "#{target}" )
        else
          puts "Skipping (already exists): #{target}"
        end
      end
    end

    def install_files(files, method = :symlink)
      files.each do |f|
        file = f.split('/').last
        source = "#{ENV['PWD']}/#{f}"
        target = "#{ENV['HOME']}/.#{file}"

        puts "======================#{file}=============================="
        puts "Source: #{source}"
        puts "Target: #{target}"

        if File.exist?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
          puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
          run %( mv "$HOME/.#{file}" "$HOME/.#{file}.backup" )
        end

        if method == :symlink
          run %( ln -nfs "#{source}" "#{target}" )
        else
          run %( cp -f "#{source}" "#{target}" )
        end

        # Temporary solution until we find a way to allow customization
        source_config_code = 'for config_file ($HOME/.lingti/zsh/*.zsh) source $config_file'
        if file == 'zshrc'
          File.open(target, 'a+') do |zshrc|
            zshrc.puts(source_config_code) if zshrc.readlines.grep(/#{Regexp.escape(source_config_code)}/).empty?
          end
        end

        puts '=========================================================='
        puts
      end
    end

    # Install progress tracking
    def install_progress_file
      File.join(File.expand_path('~/.lingti'), '.install-progress')
    end

    def completed_steps
      return [] unless File.exist?(install_progress_file)

      File.readlines(install_progress_file).map(&:strip).reject(&:empty?)
    end

    def mark_step_completed(name)
      File.open(install_progress_file, 'a') { |f| f.puts(name) }
    end

    def clear_install_progress
      FileUtils.rm_f(install_progress_file)
    end

    # Output helpers
    def success_msg(action)
      puts ''
      puts '  _     _             _   _ '
      puts ' | |   (_)_ __   __ _| |_(_)'
      puts " | |   | | '_ \\ / _` | __| |"
      puts ' | |___| | | | | (_| | |_| |'
      puts ' |_____|_|_| |_|\\__, |\\__|_|'
      puts '                 |___/       '
      puts ''
      puts '       / \\__'
      puts '      (    @\\___'
      puts '      /         O'
      puts '     /   (_____/'
      puts '    /_____/   U'
      puts ''
      puts "Lingti has been #{action}. Please restart your terminal and vim."
    end
  end
end

# Make helpers available at top level for Rake tasks
include Lingti::Helpers
