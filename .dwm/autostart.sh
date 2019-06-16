dunst &
nitrogen --restore &
$HOME/.config/i3/monitor/saver.sh &
killall conky
# /home/alexvanaxe/.config/i3/conky/conky.sh &
/home/alexvanaxe/.config/conky/day/conky.sh
compton -b &
killall dwmstatusbar
~/.dwm/dwmstatusbar &
