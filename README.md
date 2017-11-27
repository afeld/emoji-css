# Emoji CSS :smiley:

An easy way to include emoji in your HTML.

* Inspired by [Font Awesome](http://fortawesome.github.io/Font-Awesome/)
* Site ripped off of [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/)
* Uses icons from [Twemoji](https://twitter.github.io/twemoji/)

## Development

Note that the images under [`emoji/`](emoji/) are only there for legacy reasons, and are copyrighted. They will be removed at some point.

### Running Locally

```sh
bundle
bundle exec jekyll serve -w
open http://localhost:4000
```

### Updating emoji data

Pulls from [emoji-data](https://github.com/iamcal/emoji-data).

```sh
mkdir -p tmp

curl -L https://raw.githubusercontent.com/iamcal/emoji-data/master/emoji.json > tmp/emoji.json

curl -L https://api.github.com/repos/twitter/twemoji/tarball > tmp/twemoji.tar.gz
tar xf tmp/twemoji.tar.gz -C tmp

ruby update.rb
```

## See Also

* https://github.com/arvida/emoji-cheat-sheet.com#want-to-add-emojis-to-your-projects
* https://github.com/jch/html-pipeline
* https://github.com/twitter/twemoji
* http://noahmanger.github.io/emoji-text-replacement/
* https://discourse.wicg.io/t/named-emoji-entities-or-short-names/1636
* https://github.com/juanfran/emoji-data-css
