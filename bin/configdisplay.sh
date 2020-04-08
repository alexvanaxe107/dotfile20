#!/bin/sh

chosen=$(printf "Dual\\nNotebook\\nHDMI" | dmenu "$@" -i -p "Select a monitor config")

hdmi(){
    killall polybar
    $HOME/.screenlayout/hdmi.sh
    toggle_bars.sh
    #bspc monitor HDMI1 -d 1 2 3 4 5 6 7 8 9 10
}

notebook(){
    killall polybar
    $HOME/.screenlayout/notebook.sh
    toggle_bars.sh
    #bspc monitor eDP1 -d 1 2 3 4 5 6 7 8 9 10
}

dual(){
   killall polybar
   $HOME/.screenlayout/dual.sh
   sleep 1
   toggle_bars.sh
  # bspc monitor HDMI1 -d 8 9 10
  # bspc monitor eDP1 -d 1 2 3 4 5 6 7
  # bspc config -m HDMI1 top_padding 0
}

case $chosen in
    "Dual") dual;;
    "Notebook") notebook;;
    "HDMI") hdmi;;
esac
