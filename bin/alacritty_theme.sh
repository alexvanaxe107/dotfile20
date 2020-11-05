#!/bin/bash

PATH=/home/alexvanaxe/.pyenv/versions/wm/bin/:$PATH

ALACRITTY_FILE=$HOME/.config/wm/alacritty.conf

choosen_theme=$(cat $ALACRITTY_FILE |  dmenu -i -l 40 -p "Choose the terminal theme")

choosen=$(echo $choosen_theme | cut -d '|' -f 1)

if [ ! -z "$choosen" ]; then
    alacritty-colorscheme -a ${choosen} 
fi

vim_theme=$(basename -s .yaml $choosen)

cp ${HOME}/.vim/configs/theme_template.vim  ${HOME}/.vim/configs/theme.vim

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

if [ "$vim_theme" == "tomorrow_night_bright" ]; then
    sed -i 's/^colorscheme.*/colorscheme Tomorrow-Night/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="tomorrow"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "afterglow" ]; then
    sed -i 's/^colorscheme.*/colorscheme afterglow/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="afterglow"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "taerminal" ]; then
    sed -i 's/^colorscheme.*/colorscheme afterglow/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="afterglow"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    sed -i '5s/^/let g:afterglow_inherit_background=1\n/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "ayu_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme ayu/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="ayu"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    sed -i '5s/^/let ayucolor="dark"\n/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "base16_default_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme base16-default-dark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="base16_ashes"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi


if [ "$vim_theme" == "dracula" ]; then
    sed -i 's/^colorscheme.*/colorscheme dracula/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="dracula"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "falcon" ]; then
    sed -i 's/^colorscheme.*/colorscheme falcon/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="falcon"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "tango_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme tango/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="afterglow"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi
