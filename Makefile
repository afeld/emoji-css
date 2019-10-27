update:
	mkdir -p tmp

	curl -L https://raw.githubusercontent.com/iamcal/emoji-data/master/emoji_pretty.json > tmp/emoji.json

	curl -L https://api.github.com/repos/twitter/twemoji/tarball > tmp/twemoji.tar.gz
	tar xf tmp/twemoji.tar.gz -C tmp

	ruby update.rb
