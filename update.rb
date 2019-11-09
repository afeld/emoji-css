require 'json'


def sanitize(name)
  # can't have plus signs in CSS selectors
  name.gsub('+', '--')
end


json_str = File.read('tmp/emoji.json')
emoji = JSON.parse(json_str)

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

############################################

num_missing = 0

end_emoji = Dir.glob('tmp/twitter-twemoji-*/assets/72x72/*.png').map do |file|
  unicode = File.basename(file, '.*')
  e = emoji_by_unicode[unicode]
  if e.nil?
    unicode = unicode.split('-').first
    e = emoji_by_unicode[unicode]
  end

  if e
    name = sanitize(e['short_name'])

    alt_names = e['short_names']
    alt_names.delete(name)
    alt_names = alt_names.map { |n| sanitize(n) }

    {
      name: name,
      alt_names: alt_names,
      description: e['name'],
      file: unicode
    }
  else
    puts "Missing emoji data: #{unicode}"
    num_missing += 1
    nil
  end
end

puts "#{num_missing} missing"

end_emoji.compact!
end_emoji.uniq! { |e| e[:name] }
end_emoji.sort_by! { |e| e[:name] }

final_json_str = JSON.pretty_generate(end_emoji)
File.write('_data/emoji.json', final_json_str)
