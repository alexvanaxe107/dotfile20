monitor=$(xrandr --query | grep " connected" | nl | awk '{print $1}' | tail -n 1)

monitor=0

if [ $monitor -gt 1 ]; then
    cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==1 {print $2}')
else
    cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==2 {print $2}')
fi

if [ -z $cur_wallpaper ]; then
    cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==1 {print $2}')
fi



echo $cur_wallpaper
