#!/usr/bin/env bash

#xmlstarlet select --template --value-of /rss/channel/item/title --nl rss.xml

CONFIG_FILE="$HOME/.config/newsboat/urls"

fetch_rss(){
    local news_from="$(cat $CONFIG_FILE | shuf | head -n 1)"
    rsstail -u "$news_from" -1 -N -n 7 -Z "News:"
}


show_help() {
    echo "Manipulates the rss"
    echo "-f                             Fetch the page to the tmp"
}

while getopts "hf" opt; do
    case "$opt" in
    h) show_help ;;
    f) fetch_rss ;;
    esac
done
