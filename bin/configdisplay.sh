#!/bin/sh

chosen=$(printf "Dual\\nDual Inverted\\nNotebook\\nHDMI\\nDual DPI" | dmenu -i -p "Select a monitor config")

hdmi(){
    $HOME/.screenlayout/hdmi.sh
    #toggle_bars.sh --restart
    #bspc monitor HDMI1 -d 1 2 3 4 5 6 7 8 9 10
}

notebook(){
    $HOME/.screenlayout/notebook.sh
    #toggle_bars.sh --restart
    #bspc monitor eDP1 -d 1 2 3 4 5 6 7 8 9 10
}

dual_inverted(){
   $HOME/.screenlayout/dual_inverted.sh
   #sleep 1
   #toggle_bars.sh --restart
}

dual(){
   $HOME/.screenlayout/dual.sh
   #sleep 1
   #toggle_bars.sh --restart
}

dual_dpi(){
   $HOME/.screenlayout/dual_dpi.sh
   #sleep 1
   #toggle_bars.sh --restart
}

case $chosen in
    "Dual") dual;;
    "Dual Inverted") dual_inverted;;
    "Notebook") notebook;;
    "HDMI") hdmi;;
    "Dual DPI") dual_dpi;;
esac
