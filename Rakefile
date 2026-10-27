# frozen_string_literal: true

require 'rake'
require 'English'

# Belt-and-braces: ensure no Homebrew prompt fires even when the user runs
# `rake install` directly (not via install.sh, which sets these too). The
# main offender is HOMEBREW_ASK (defaults to on in recent brew versions),
# which triggers "Do you want to proceed? [y/n]" for multi-formula installs.
ENV['HOMEBREW_ASK']               ||= ''
ENV['HOMEBREW_NO_ENV_HINTS']      ||= '1'
ENV['HOMEBREW_NO_INSTALL_CLEANUP']||= '1'
ENV['HOMEBREW_NO_AUTO_UPDATE']    ||= '1'
ENV['NONINTERACTIVE']             ||= '1'

# Load helpers
require_relative 'lib/helpers.rb'

# Load all task files
Dir.glob('lib/tasks/*.rake').each { |r| load r }
