# frozen_string_literal: true

def install_term_theme
  puts '======================================================'
  puts 'Installing iTerm2 solarized theme.'
  puts '======================================================'
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Light.itermcolors' :'Custom Color Presets':'Solarized Light'" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" ~/Library/Preferences/com.googlecode.iterm2.plist )

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  unless File.exist?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts '======================================================'
    puts 'To make sure your profile is using the solarized theme'
    puts 'Please check your settings under:'
    puts 'Preferences> Profiles> [your profile]> Colors> Load Preset..'
    puts '======================================================'
    return
  end

  # No prompts: always apply Solarized Dark to every profile. Switch to
  # a different preset in iTerm2 → Preferences → Profiles → Colors → Load
  # Presets… (both Solarized Light and Solarized Dark are already merged
  # into the plist above).
  color_scheme = 'Solarized Dark'
  color_scheme_file = File.join('iTerm2', "#{color_scheme}.itermcolors")
  puts "Applying '#{color_scheme}' to all iTerm2 profiles."

  profiles = iTerm_profile_list
  profiles.size.times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
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
