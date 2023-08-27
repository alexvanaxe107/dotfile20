#!/usr/bin/env bash

#xmlstarlet select --template --value-of /rss/channel/item/title --nl rss.xml

CONFIG_FILE="$HOME/.config/wm/rss"

fetch_rss(){
    rsstail -u $(cat $CONFIG_FILE) -1 -N -n 5 -Z "News:"
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
