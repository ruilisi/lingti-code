# frozen_string_literal: true

desc 'Apply Solarized Dark + JetBrainsMono Nerd Font to every iTerm2 profile. Run after launching iTerm2 at least once.'
task :install_term_theme do
  install_term_theme
end

ITERM_PLIST = File.expand_path('~/Library/Preferences/com.googlecode.iterm2.plist').freeze
# PostScript name is baked into the font file metadata; cask
# `font-jetbrains-mono-nerd-font` installs this variant as
# ~/Library/Fonts/JetBrainsMonoNerdFontMono-Regular.ttf.
ITERM_NERD_FONT = 'JetBrainsMonoNerdFontMono-Regular 13'

def install_term_theme
  puts '======================================================'
  puts 'Configuring iTerm2 (Solarized Dark + JetBrainsMono Nerd Font).'
  puts '======================================================'

  unless File.exist?(ITERM_PLIST)
    puts 'iTerm2 preferences not initialized yet — launch iTerm2.app once'
    puts 'so it writes its plist, then re-run: `cd ~/.lingti && rake install_term_theme`'
    return
  end

  # Quit iTerm if it's running — in-memory state would overwrite our plist
  # edits on exit. Harmless no-op when iTerm isn't open.
  run %( osascript -e 'tell application "iTerm" to quit' 2>/dev/null || true )

  # Merge both Solarized presets into Custom Color Presets so the user
  # can also pick Light later from Preferences → Colors → Load Presets.
  %w[Light Dark].each do |variant|
    run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized #{variant}' dict" "#{ITERM_PLIST}" 2>/dev/null )
    run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized #{variant}.itermcolors' :'Custom Color Presets':'Solarized #{variant}'" "#{ITERM_PLIST}" )
  end

  color_scheme_file = File.join('iTerm2', 'Solarized Dark.itermcolors')
  profiles = iTerm_profile_list
  puts "Applying Solarized Dark + #{ITERM_NERD_FONT.inspect} to #{profiles.size} iTerm2 profile(s)."

  profiles.size.times do |idx|
    apply_theme_to_iterm_profile_idx(idx, color_scheme_file)
    set_iterm_profile_font(idx, ITERM_NERD_FONT)
  end
end

def set_iterm_profile_font(index, font)
  # 'Normal Font' is the ASCII glyph font; 'Non Ascii Font' is used for
  # CJK + box-drawing + icons. Setting both to the Nerd Font avoids glyph
  # fallback mid-line (which makes prompt arrows / git-status icons jump).
  %w[Normal\ Font Non\ Ascii\ Font].each do |key|
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
