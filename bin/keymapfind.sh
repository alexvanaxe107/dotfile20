#!/bin/sh

if [[ ! -z "$1" ]]; then
    grep $1 /home/alexvanaxe/Documents/Projects/dwm/keymmap.txt
else
    cat /home/alexvanaxe/Documents/Projects/dwm/keymmap.txt | more
fi
