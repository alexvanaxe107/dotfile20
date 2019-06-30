dunst &
nitrogen --restore &
$HOME/.config/i3/monitor/saver.sh &
killall conky
/home/alexvanaxe/.config/i3/conky/conky.sh &
#/home/alexvanaxe/.config/conky/night/conky.sh
compton -b &
killall stalonetray &
stalonetray &
killall dwmstatusbar
~/.dwm/dwmstatusbar &
