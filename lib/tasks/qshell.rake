# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'tmpdir'

desc 'Install latest qshell from GitHub releases'
task :install_qshell do
  install_dir = File.expand_path('~/bin')
  FileUtils.mkdir_p(install_dir)

  # Detect OS
  os = if macos?
         'darwin'
       elsif linux?
         'linux'
       else
         abort 'Unsupported OS'
       end

  # Detect architecture
  arch = case `uname -m`.strip
         when 'x86_64', 'amd64'
           'amd64'
         when 'arm64', 'aarch64'
           'arm64'
         when 'i386', 'i686'
           '386'
         when /^arm/
           'arm'
         else
           abort "Unsupported architecture: #{`uname -m`.strip}"
         end

  puts "Detected: #{os}-#{arch}"

  # Fetch latest release version from GitHub API using curl
  puts 'Fetching latest release info...'
  api_url = 'https://api.github.com/repos/qiniu/qshell/releases/latest'
  response = `curl -fsSL -H "Accept: application/vnd.github.v3+json" "#{api_url}" 2>&1`
  abort "Failed to fetch release info: #{response}" unless $?.success?

  release = JSON.parse(response)
  version = release['tag_name']
  puts "Latest version: #{version}"

  # Find the matching asset
  filename = "qshell-#{version}-#{os}-#{arch}.tar.gz"
  asset = release['assets'].find { |a| a['name'] == filename }
  abort "No binary found for #{os}-#{arch}" unless asset

  download_url = asset['browser_download_url']
  puts "Downloading #{filename}..."

  # Download to temp directory
  tmp_dir = Dir.mktmpdir
  tmp_file = File.join(tmp_dir, filename)

  system(%(curl -fSL "#{download_url}" -o "#{tmp_file}"))
  abort 'Download failed' unless $?.success? && File.exist?(tmp_file)

  # Extract
  puts 'Extracting...'
  system(%(tar -xzf "#{tmp_file}" -C "#{tmp_dir}"))

  # Find the qshell binary (it's directly in the tarball)
  qshell_bin = File.join(tmp_dir, 'qshell')
  abort 'qshell binary not found in archive' unless File.exist?(qshell_bin)

  # Install to ~/bin
  dest = File.join(install_dir, 'qshell')
  puts "Installing to #{dest}..."
  FileUtils.cp(qshell_bin, dest)
  FileUtils.chmod(0o755, dest)

  # Cleanup
  FileUtils.rm_rf(tmp_dir)

  puts "qshell #{version} installed successfully!"
  puts "Make sure #{install_dir} is in your PATH"
end
