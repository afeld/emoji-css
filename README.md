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

Requires [jq](https://stedolan.github.io/jq/). Pulls from [emoji-data](https://github.com/iamcal/emoji-data).

<!-- https://stackoverflow.com/a/46293052/358804 -->
```sh
curl -L -s https://github.com/iamcal/emoji-data/raw/master/emoji.json | jq -r '[.[] | select(.has_img_twitter == true) | with_entries(select([.key] | inside(["short_name", "unified"])))]' > _data/emoji.json
```

## See Also

* https://github.com/arvida/emoji-cheat-sheet.com#want-to-add-emojis-to-your-projects
* https://github.com/jch/html-pipeline
* https://github.com/twitter/twemoji
* http://noahmanger.github.io/emoji-text-replacement/
* https://discourse.wicg.io/t/named-emoji-entities-or-short-names/1636
* https://github.com/juanfran/emoji-data-css
