#!/bin/sh

chosen=$(printf "Dual\\nNotebook\\nHDMI" | dmenu "$@" -i -p "Select a monitor config")

function hdmi(){
    killall polybar
    $HOME/.screenlayout/hdmi.sh
    toggle_bars.sh
    #bspc monitor HDMI1 -d 1 2 3 4 5 6 7 8 9 10
}

function notebook(){
    killall polybar
    $HOME/.screenlayout/notebook.sh
    toggle_bars.sh
    #bspc monitor eDP1 -d 1 2 3 4 5 6 7 8 9 10
}

function dual_inverted(){
   killall polybar
   $HOME/.screenlayout/dual_inverted.sh
   sleep 1
   toggle_bars.sh
}

function dual(){
   killall polybar
   $HOME/.screenlayout/dual.sh
   sleep 1
   toggle_bars.sh
}

case $chosen in
    "Dual") dual;;
    "Dual Inverted") dual_inverted;;
    "Notebook") notebook;;
    "HDMI") hdmi;;
esac
