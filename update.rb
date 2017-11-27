require 'json'

# https://unicode.org/reports/tr51/#Emoji_Modifiers_Table
MODIFIER_NAMES_BY_CODE = {
  '1F3FB' => 'light',
  '1F3FC' => 'medium-light',
  '1F3FD' => 'medium',
  '1F3FE' => 'medium-dark',
  '1F3FF' => 'dark'
}

json_str = File.read('tmp/emoji.json')
emoji = JSON.parse(json_str)

emoji = emoji.flat_map do |e|
  variations = e['skin_variations'] || {}
  variations.each do |modifier, variation|
    mod_name = MODIFIER_NAMES_BY_CODE[modifier]
    if mod_name.nil?
      puts "Unknown modifier: #{modifier}"
    end

    variation['short_name'] ||= e['short_name'] + '-' + mod_name
    variation['short_names'] ||= e['short_names'].map { |sn| "#{sn} - #{mod_name}" }
  end

  [e] + variations.values
end

emoji_by_unicode = {}


## do multiple passes, adding the variants in decreasing order of preference ##

# unified
emoji.each do |e|
  unicode = e['unified'].downcase
  emoji_by_unicode[unicode] = e
end

# non-qualified
emoji.each do |e|
  if e['non_qualified']
    unicode = e['non_qualified'].downcase
    emoji_by_unicode[unicode] ||= e
  end
end

# unified, without leading 00s
emoji.each do |e|
  unicode = e['unified'].downcase
  if unicode.start_with? '00'
    unicode = unicode[2,2]
    emoji_by_unicode[unicode] ||= e

    # adding a "COMBINING ENCLOSING KEYCAP"
    # https://github.com/iamcal/emoji-data/blob/f9f01088a660cfd17bd20aec78daeebb96621aa2/build/twitter/grab.php#L28
    unicode += '-20e3'
    emoji_by_unicode[unicode] ||= e
  end
end

# unified, first part
emoji.each do |e|
  unified = e['unified'].downcase.split('-').first
  emoji_by_unicode[unified] ||= e
end

############################################


end_emoji = Dir.glob('tmp/twitter-twemoji-*/2/72x72/*.png').map do |file|
  unicode = File.basename(file, '.*')
  e = emoji_by_unicode[unicode]
  if e.nil?
    unicode = unicode.split('-').first
    e = emoji_by_unicode[unicode]
  end

  if e
    name = e['short_name']
    # can't have plus signs in CSS selectors
    name = name.gsub('+', '--')

    alt_names = e['short_names']
    alt_names.delete(name)

    {
      name: name,
      alt_names: alt_names,
      file: unicode
    }
  else
    puts "Missing emoji data: #{unicode}"
    nil
  end
end

end_emoji.compact!
# since `uniq!` takes the first match, pre-sort by the simplest filename variant
end_emoji.sort_by! { |e| e[:file] }
end_emoji.uniq! { |e| e[:name] }
end_emoji.sort_by! { |e| e[:name] }

final_json_str = JSON.pretty_generate(end_emoji)
File.write('_data/emoji.json', final_json_str)
