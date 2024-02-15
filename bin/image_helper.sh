#!/usr/bin/env bash

display_dimensions() {
    identify -format "%wx%h" $1 | xargs
}

multiply_dimension() {
    local file="$1"
    local width="$(echo "$(identify -format "%w" $1 | xargs) * $multiply/1" | bc)"
    local height="$(echo "$(identify -format "%h" $1 | xargs) * $multiply/1" | bc)"

    echo "${width}x${height}"
}

halth_width(){
    local file="$1"
    local width="$(echo "$(identify -format "%w" $1 | xargs) * $multiply/1" | bc)"
    local height="$(identify -format "%h" $1 | xargs)"

    echo "${width}x${height}"
}

show_help() {
    echo "Get some dimensions"
    echo "d                   Get the dimensions of the image"
    echo "m {miltiplier}      Multiply the image dimensions"
    echo "w {multiplier}      Multiply only the width"
}

req_command=""
multiply=""

while getopts "h?dm:w:" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        d) req_command="d";;
        m) req_command="m"; multiply="$OPTARG";;
        w) req_command="w"; multiply="$OPTARG";;
    esac
done

shift $((OPTIND-1))

case "${req_command}" in
    "d") display_dimensions $1;;
    "m") multiply_dimension $1;;
    "w") halth_width $1;;
    *) show_help;;
esac


