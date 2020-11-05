#!/bin/bash

PATH=/home/alexvanaxe/.pyenv/versions/wm/bin/:$PATH

choosen=$(alacritty-colorscheme -l | dmenu -i -l 40 -p "Choose the terminal theme")

if [ ! -z "$choosen" ]; then
    alacritty-colorscheme -a ${choosen} 
fi

vim_theme=$(basename -s .yaml $choosen)

echo $vim_theme

if [ "$vim_theme" == "breeze" ]; then
    sed -i 's/^colorscheme.*/colorscheme breezy/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="breezy"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "papercolor_light" ]; then
    sed -i 's/^colorscheme.*/colorscheme PaperColor/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="papercolor"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "gruvbox_light" ]; then
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "gruvbox_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "gotham" ]; then
    sed -i 's/^colorscheme.*/colorscheme gotham/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gotham"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "material_theme" ]; then
    sed -i 's/^colorscheme.*/colorscheme material/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="material"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "nord" ]; then
    sed -i 's/^colorscheme.*/colorscheme nord/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="nord"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "thelovelace" ]; then
    sed -i 's/^colorscheme.*/colorscheme nord/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="nord"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "tomorrow_night" ]; then
    sed -i 's/^colorscheme.*/colorscheme Tomorrow-Night/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="tomorrow"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi
