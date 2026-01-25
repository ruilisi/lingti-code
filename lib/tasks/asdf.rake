# frozen_string_literal: true

desc 'Install asdf version manager'
task :install_asdf do
  run 'git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1'
  install_files(Dir.glob('asdf/*')) if want_to_install?('tool version manager asdf')
  run %(bash -c '
    . $HOME/.asdf/asdf.sh
    asdf plugin-add kubetail https://github.com/janpieper/asdf-kubetail.git
    asdf install
  ')
end
