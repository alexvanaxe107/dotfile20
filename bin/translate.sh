#! /bin/bash

translate() {
    if [ -z "$1" ]; then
        local trad="$(xclip -o -sel clipboard)"
        trans :pt "$trad"
    else
        trans :pt "$1"
    fi

    read
}

show_help() {
    echo "Do some translation and show it"
    echo "-t                         translate and show"
}

rcommand="0"

while getopts "h?t" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        t) rcommand="t";;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "t") translate "$1";;
esac
