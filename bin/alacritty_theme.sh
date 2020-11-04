#!/bin/dash

PATH=/home/alexvanaxe/.pyenv/versions/wm/bin/:$PATH

choosen=$(alacritty-colorscheme -l | dmenu -i -l 40 -p "Choose the terminal theme")

if [ ! -z "$choosen" ]; then
    alacritty-colorscheme -a ${choosen} 
fi
