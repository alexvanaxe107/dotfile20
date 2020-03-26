echo teste

displays=$(xrandr --listmonitors | awk 'NR==1 {print $2}')

if [ "$displays" -gt "1" ]; then
    echo "MAIOR"
else
    echo "MENOR"
fi
