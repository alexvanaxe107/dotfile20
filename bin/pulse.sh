#! /bin/bash

. $HOME/.pyenv/versions/wm/bin/activate

source ~/.config/wm/pulse.conf

pulse_terminal(){
    barva pulse-term --cfrom "${from}" --cto "${to}"  &
}

pulse_fire(){
    barva pulse-fire --cfrom "${from}" --cto "${to}" &
}

rcommand="0"

show_help() {
    echo "Make the things dance"
    echo "-t    Make the terminal dance"
    echo "-f    Put some fire"
}

while getopts "h?tf" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        t) rcommand='t' ;;
        f) rcommand='f' ;;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "t") pulse_terminal;;
    "f") pulse_fire;;
esac
