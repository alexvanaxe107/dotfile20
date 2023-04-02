#!/bin/bash

DP="DisplayPort-2"
game="$(which $1)"
tmp_start=/tmp/start_tmp.sh
cp /home/alexvanaxe/bin/start_tmp.sh ${tmp_start}
dim=$(printf "%s\n%s\n%s\n" "3840x2160" "2560x1440" "1920x1080" | fzf)

echo -e "xrandr --output $DP --mode '$dim'" >> ${tmp_start}
openbox="$(which openbox)"

if [ "$1" == "steam" ]; then
    echo -e "${openbox} &\ngamemoderun ${game}" -gamepadui >> ${tmp_start}
else
    echo -e "${openbox} &\ngamemoderun ${game}" >> ${tmp_start}
fi

xinit ${tmp_start} -- :1 vt$XDG_VTNR || exit 1
