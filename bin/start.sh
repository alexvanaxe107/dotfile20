#!/bin/bash

is_openbox=0
if [ ! -z "$(command -v openbox)" ]; then
    is_openbox=1
else
    echo "In case of problems in resolution or any other issues, please install openbox"
fi

DP="DisplayPort-2"
game="$(which $1)"
tmp_start=/tmp/start_tmp.sh
cp /home/alexvanaxe/bin/start_tmp.sh ${tmp_start}

dimensions="$(cat $HOME/.config/wm/monitor_options.conf)"
dim=$(printf "$dimensions" | fzf)
dim=$(awk '{print $1}' <<< "${dim}")

echo "Iniciando $1 em modo $dim. Enjoy!"
sleep 2

echo -e "xrandr --output $DP --mode '$dim'" >> ${tmp_start}
echo -e "xrandr --output $DP --set TearFree on" >> ${tmp_start}

if [ ${is_openbox} == 1 ]; then
    openbox="$(which openbox) &\n "
fi

if [ "$1" == "steam" ]; then
    echo -e "${openbox}gamemoderun ${game}" -gamepadui >> ${tmp_start}
else
    echo -e "${openbox}gamemoderun ${game}" >> ${tmp_start}
fi
xsetroot -cursor_name left_ptr
xinit ${tmp_start} -- :1 vt$XDG_VTNR || exit 1
