#!/bin/sh

chosen=$(printf "Dual\\nNotebook\\nHDMI" | dmenu "$@" -i -p "Select a monitor config")

hdmi(){
    $HOME/.screenlayout/hdmi.sh
    #bspc monitor HDMI1 -d 1 2 3 4 5 6 7 8 9 10
}

notebook(){
    $HOME/.screenlayout/notebook.sh
    #bspc monitor eDP1 -d 1 2 3 4 5 6 7 8 9 10
}

dual(){
   $HOME/.screenlayout/dual.sh
  # bspc monitor HDMI1 -d 8 9 10
  # bspc monitor eDP1 -d 1 2 3 4 5 6 7
  # bspc config -m HDMI1 top_padding 0
}

case $chosen in
    "Dual") dual;;
    "Notebook") notebook;;
    "HDMI") hdmi;;
esac
