# frozen_string_literal: true

desc 'Apply Solarized Dark to every iTerm2 profile. Run after launching iTerm2 at least once.'
task :install_term_theme do
  install_term_theme
end

desc 'Set JetBrainsMono Nerd Font on every iTerm2 profile that is not already using a Nerd Font.'
task :install_iterm_font do
  install_iterm_font
end

ITERM_PLIST = File.expand_path('~/Library/Preferences/com.googlecode.iterm2.plist').freeze
# PostScript name is baked into the font file metadata; cask
# `font-jetbrains-mono-nerd-font` installs this variant as
# ~/Library/Fonts/JetBrainsMonoNerdFontMono-Regular.ttf.
ITERM_NERD_FONT = 'JetBrainsMonoNerdFontMono-Regular 13'

def install_term_theme
  puts '======================================================'
  puts 'Installing iTerm2 solarized theme.'
  puts '======================================================'

  unless File.exist?(ITERM_PLIST)
    puts 'iTerm2 preferences not initialized yet — launch iTerm2.app once'
    puts 'so it writes its plist, then re-run: `cd ~/.lingti && rake install_term_theme`'
    return
  end

  iterm_quit_if_running

  # Merge both Solarized presets into Custom Color Presets so the user
  # can also pick Light later from Preferences → Colors → Load Presets.
  %w[Light Dark].each do |variant|
    run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized #{variant}' dict" "#{ITERM_PLIST}" 2>/dev/null )
    run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized #{variant}.itermcolors' :'Custom Color Presets':'Solarized #{variant}'" "#{ITERM_PLIST}" )
  end

  color_scheme_file = File.join('iTerm2', 'Solarized Dark.itermcolors')
  profiles = iTerm_profile_list
  puts "Applying Solarized Dark to #{profiles.size} iTerm2 profile(s)."
  profiles.size.times { |idx| apply_theme_to_iterm_profile_idx(idx, color_scheme_file) }
end

def install_iterm_font
  puts '======================================================'
  puts 'Binding iTerm2 profiles to JetBrainsMono Nerd Font.'
  puts '======================================================'

  unless File.exist?(ITERM_PLIST)
    puts 'iTerm2 preferences not initialized yet — launch iTerm2.app once'
    puts 'so it writes its plist, then re-run: `cd ~/.lingti && rake install_iterm_font`'
    return
  end

  profiles = iTerm_profile_list
  if profiles.empty?
    puts 'No iTerm2 profiles found; nothing to bind.'
    return
  end

  needs_binding = profiles.each_index.reject { |idx| profile_has_nerd_font?(idx) }
  if needs_binding.empty?
    puts "All #{profiles.size} profile(s) already use a Nerd Font — nothing to do."
    return
  end

  iterm_quit_if_running
  puts "Setting #{ITERM_NERD_FONT.inspect} on #{needs_binding.size}/#{profiles.size} profile(s)."
  needs_binding.each { |idx| set_iterm_profile_font(idx, ITERM_NERD_FONT) }
end

def iterm_quit_if_running
  # In-memory iTerm state is flushed on exit and would clobber our plist
  # edits. Harmless no-op when iTerm isn't open.
  run %( osascript -e 'tell application "iTerm" to quit' 2>/dev/null || true )
end

def profile_has_nerd_font?(index)
  current = `/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{index}:'Normal Font'" "#{ITERM_PLIST}" 2>/dev/null`.strip
  # Any Nerd Font / JetBrains variant counts as "already bound" — avoid
  # overwriting a deliberate user choice (FiraCode Nerd Font, Hack Nerd
  # Font, etc.) just because it isn't ours.
  current.match?(/Nerd ?Font|JetBrains/i)
end

def set_iterm_profile_font(index, font)
  # 'Normal Font' is the ASCII glyph font; 'Non Ascii Font' is used for
  # CJK + box-drawing + icons. Setting both to the Nerd Font avoids glyph
  # fallback mid-line (which makes prompt arrows / git-status icons jump).
  # NOTE: regular array literal — %w[] splits on any whitespace, so
  # `%w[Normal\ Font Non\ Ascii\ Font]` ends up with the words broken
  # apart (seen in testing: Non Ascii Font silently didn't update).
  ['Normal Font', 'Non Ascii Font'].each do |key|
    run %( /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':#{index}:'#{key}' '#{font}'" "#{ITERM_PLIST}" 2>/dev/null ||
           /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':#{index}:'#{key}' string '#{font}'" "#{ITERM_PLIST}" )
  end
end

def iTerm_available_themes
  Dir['iTerm2/*.itermcolors'].map { |value| File.basename(value, '.itermcolors') } << 'None'
end

def iTerm_profile_list
  profiles = []
  begin
    profiles << `/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null`
  end while $CHILD_STATUS.exitstatus == 0
  profiles.pop
  profiles
end

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = []
  16.times { |i| values << "Ansi #{i} Color" }
  values << ['Background Color', 'Bold Color', 'Cursor Color', 'Cursor Text Color', 'Foreground Color',
             'Selected Text Color', 'Selection Color']
  values.flatten.each do |entry|
    run %( /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" ~/Library/Preferences/com.googlecode.iterm2.plist )
  end

  run %( /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( defaults read com.googlecode.iterm2 )
end
