require 'net/http'
require 'json'

src = 'https://raw.githubusercontent.com/iamcal/emoji-data/master/emoji.json'
json_str = Net::HTTP.get(URI(src))
emoji = JSON.parse(json_str)

emoji.select! { |e| e['has_img_twitter'] }

emoji.map! do |e|
  name = e['short_name']

  # can't have plus signs in CSS selectors
  name.gsub!('+', '--')

  file = e['unified'].downcase.split('-').first
  # https://github.com/iamcal/emoji-data/blob/f9f01088a660cfd17bd20aec78daeebb96621aa2/build/twitter/grab.php#L28
  if file.start_with? '00'
    file = file[2,2] + '-20e3'
  end

  {
    name: name,
    file: file
  }
end

emoji.sort_by! { |e| e[:name] }

final_json_str = JSON.pretty_generate(emoji)
File.write('_data/emoji.json', final_json_str)
