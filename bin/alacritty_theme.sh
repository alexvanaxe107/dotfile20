#!/bin/bash

PATH=$HOME/.pyenv/versions/wm/bin/:$PATH

ALACRITTY_FILE=$HOME/.config/wm/alacritty.conf

choosen_theme=$(cat $ALACRITTY_FILE |  dmenu -i -y 16 -bw 2 -z 850 -l 27 -p "Choose the terminal theme")

choosen=$(echo $choosen_theme | cut -d '|' -f 1)

if [ ! -z "$choosen" ]; then
    cp ${HOME}/.vim/configs/theme_template.vim  ${HOME}/.vim/configs/theme.vim
    alacritty-colorscheme apply "${choosen}"
fi

vim_theme=$(basename -s .yaml "$choosen")

echo "${vim_theme}"

if [ "$vim_theme" == "breeze" ]; then
    sed -i 's/^colorscheme.*/colorscheme breezy/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="breezy"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Codeschool.light" ]; then
    sed -i 's/^colorscheme.*/colorscheme OceanicNextLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="oceanicnextlight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Brewer.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme OceanicNextLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="oceanicnextlight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "papercolor_light" ]; then
    sed -i 's/^colorscheme.*/colorscheme PaperColor/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="papercolor"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Zenburn" ]; then
    sed -i 's/^colorscheme.*/colorscheme zenburn/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="zenburn"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "pencil_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme pencil/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="pencil"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:pencil_terminal_italics = 1" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "pencil_light" ]; then
    sed -i 's/^colorscheme.*/colorscheme pencil/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="pencil"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:pencil_terminal_italics = 1" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "gruvbox_light" ]; then
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:gruvbox_italic=1" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "3024.dark.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme base16-3024/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="base16_3024"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "OK100 - Matrix.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme base16-greenscreen/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="base16_greenscreen"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "gruvbox_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:gruvbox_italic=1" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "gruvbox_material.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme gruvbox-material/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox_material"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "argonaut" ]; then
    sed -i 's/^colorscheme.*/colorscheme argonaut/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gotham"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "gotham" ]; then
    sed -i 's/^colorscheme.*/colorscheme gotham/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gotham"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "cyber_punk_neon" ]; then
    sed -i 's/^colorscheme.*/colorscheme synthwave84/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="synthwave84"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Dawn.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme dogrun/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="synthwave84"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Cloud.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme synthwave84/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="synthwave84"/' ${HOME}/.vim/configs/theme.vim
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
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:gruvbox_transparent_bg=1" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "Trim-yer-beard.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:gruvbox_transparent_bg=1" >> ${HOME}/.vim/configs/theme_config.vim
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
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:afterglow_inherit_background=1" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "ayu_dark" ]; then
    sed -i 's/^colorscheme.*/colorscheme ayu/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="ayu"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    sed -i '5s/^/let ayucolor="dark"\n/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Chalk" ]; then
    sed -i 's/^colorscheme.*/colorscheme onehalflight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="onehalflight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
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
    echo "" > ${HOME}/.vim/configs/theme_config.vim
    echo "let g:dracula_colorterm = 0" >> ${HOME}/.vim/configs/theme_config.vim
fi

if [ "$vim_theme" == "dracula_deep_space" ]; then
    sed -i 's/^colorscheme.*/colorscheme deep-space/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="deep_space"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "oceanic_next" ]; then
    sed -i 's/^colorscheme.*/colorscheme OceanicNext/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="oceanicnext"/' ${HOME}/.vim/configs/theme.vim
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

if [ "$vim_theme" == "Nova.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_CaveLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_CaveLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Grayscale.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme base16-grayscale-light/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="base16_grayscale"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Embers.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme corvine_light/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_HeathLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi
if [ "$vim_theme" == "Paraiso.light" ]; then
    sed -i 's/^colorscheme.*/colorscheme github/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="github"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Muzieca mono.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme monochrome/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="base16_grayscale"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierdune.dark.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_DuneDark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_DuneDark"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierdune.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_DuneLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_DuneLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierforest.dark.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_ForestDark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_ForestDark"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierforest.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_ForestLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_ForestLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierheath.dark.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_HeathDark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_HeathDark"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierheath.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_HeathLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_HeathLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierlakeside.dark.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_LakesideDark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_LakesideDark"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierlakeside.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_LakesideLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_LakesideLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierseaside.dark.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_SeasideDark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_SeasideDark"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
fi

if [ "$vim_theme" == "Atelierseaside.light.yml" ]; then
    sed -i 's/^colorscheme.*/colorscheme Atelier_SeasideLight/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="Atelier_SeasideLight"/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
fi
