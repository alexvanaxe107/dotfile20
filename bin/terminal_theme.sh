#!/usr/bin/env bash

source $HOME/.config/bspwm/themes/bsp.cfg

PATH=$HOME/.pyenv/versions/wm/bin/:$PATH

THEMES=$HOME/.config/wm/terminal.conf
TERM_CONFIG=$HOME/.config/wezterm/extra.lua
BSPWM_CONFIG="$HOME/.config/wm/bspwm.conf"

THEME_NAME="${theme_name}"

dmenu=ava_dmenu

choosen_theme=$((printf "Theme on\nTheme off\nWal\n" && cat $THEMES) |  ${dmenu} -i -l 27 -p "Choose the terminal theme")

choosen=$(echo $choosen_theme | cut -d '|' -f 1)

echo "" > ${HOME}/.vim/configs/theme_config.vim

if [ "${choosen}" == "Theme on" ]; then
    sed -i "s/\(custom_colors = \)\(.*\),/\1true,/" ${HOME}/.config/wezterm/extra.lua
    exit
fi
if [ "${choosen}" == "Theme off" ]; then
    sed -i "s/\(custom_colors = \)\(.*\),/\1false,/" ${HOME}/.config/wezterm/extra.lua
    exit
fi
if [ "${choosen}" == "Wal" ]; then
    sed -i 's/^colorscheme.*/colorscheme wal/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="wal"/' ${HOME}/.vim/configs/theme.vim
    if [ "${THEME_NAME}" == "day"  ]; then
        wal -n -l -i $(cat $HOME/wallpaper.txt)
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    else
        wal -n -i $(cat $HOME/wallpaper.txt)
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi
    sed -i 's/wal_enabled.*/wal_enabled="1"/' ${BSPWM_CONFIG}
    echo "set termguicolors!" > ${HOME}/.vim/configs/theme_config.vim

    exit
else
    sed -i 's/wal_enabled.*/wal_enabled="0"/' ${BSPWM_CONFIG}
fi

if [ ! -z "$choosen" ]; then
    cp ${HOME}/bin/templates/vim/theme.vim  ${HOME}/.vim/configs/theme.vim

    vim_theme=$(basename -s .yaml "$choosen")
    sed -i "s/theme_name.*/theme_name = \"$vim_theme\",/" $TERM_CONFIG

    if [ "$vim_theme" == "Breeze" ]; then
        sed -i 's/^colorscheme.*/colorscheme breezy/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="breezy"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Material" ]; then
        sed -i 's/^colorscheme.*/colorscheme material-lighter/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="material"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=/light' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Codeschool.light" ]; then
        sed -i 's/^colorscheme.*/colorscheme OceanicNextLight/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="oceanicnextlight"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "neobones_light" ]; then
        sed -i 's/^colorscheme.*/colorscheme Atelier_SeasideLight/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="base16-harmonic-light"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "tokyonight-day" ]; then
        sed -i 's/^colorscheme.*/colorscheme tokyonight/' ${HOME}/.vim/configs/theme.vim
        #    sed -i 's/airline_theme.*/airline_theme="tokyounight"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Ocean (light) (terminal.sexy)" ]; then
        sed -i 's/^colorscheme.*/colorscheme OceanicNextLight/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="oceanicnextlight"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "PaperColorLight (Gogh)" ]; then
        sed -i 's/^colorscheme.*/colorscheme PaperColor/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="papercolor"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Zenburn" ]; then
        sed -i 's/^colorscheme.*/colorscheme zenburn/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="zenburn"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "tokyonight" ]; then
        sed -i 's/^colorscheme.*/colorscheme tokyonight/' ${HOME}/.vim/configs/theme.vim
        #    sed -i 's/airline_theme.*/airline_theme="zenburn"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Sakura" ]; then
        sed -i 's/^colorscheme.*/colorscheme shado/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="shado"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=/dark' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "PencilLight" ]; then
        sed -i 's/^colorscheme.*/colorscheme pencil/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="pencil"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
        echo "" > ${HOME}/.vim/configs/theme_config.vim
        echo "let g:pencil_terminal_italics = 1" >> ${HOME}/.vim/configs/theme_config.vim
    fi

    if [ "$vim_theme" == "PencilDark" ]; then
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

    if [ "$vim_theme" == "Gruvbox Light" ]; then
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

    if [ "$vim_theme" == "GruvboxDark" ]; then
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

    if [ "$vim_theme" == "Argonaut" ]; then
        sed -i 's/^colorscheme.*/colorscheme argonaut/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="gotham"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "palenight (Gogh)" ]; then
        sed -i 's/^colorscheme.*/colorscheme palenight/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="palenight"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "gotham (Gogh)" ]; then
        sed -i 's/^colorscheme.*/colorscheme gotham/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="gotham"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "cyberpunk" ]; then
        sed -i 's/^colorscheme.*/colorscheme synthwave84/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="synthwave"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Dawn (terminal.sexy)" ]; then
        sed -i 's/^colorscheme.*/colorscheme dogrun/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="synthwave84"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Cloud (terminal.sexy)" ]; then
        sed -i 's/^colorscheme.*/colorscheme synthwave84/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="synthwave84"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "MaterialDark" ]; then
        sed -i 's/^colorscheme.*/colorscheme material/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="material"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi


    if [ "$vim_theme" == "material_theme_light" ]; then
        sed -i 's/^colorscheme.*/colorscheme material/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="material"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
        echo "" > ${HOME}/.vim/configs/theme_config.vim
        echo "let g:material_style = \"lighter\"" >> ${HOME}/.vim/configs/theme_config.vim
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

    if [ "$vim_theme" == "Afterglow" ]; then
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

    if [ "$vim_theme" == "Azu (Gogh)" ]; then
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


    if [ "$vim_theme" == "Dracula" ]; then
        sed -i 's/^colorscheme.*/colorscheme dracula/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="dracula"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
        echo "" > ${HOME}/.vim/configs/theme_config.vim
        echo "let g:dracula_colorterm = 0" >> ${HOME}/.vim/configs/theme_config.vim
    fi

    if [ "$vim_theme" == "Galaxy" ]; then
        sed -i 's/^colorscheme.*/colorscheme deep-space/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="deep_space"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Oceanic-Next" ]; then
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

    if [ "$vim_theme" == "Grayscale (light) (terminal.sexy)" ]; then
        sed -i 's/^colorscheme.*/colorscheme base16-grayscale-light/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="base16_grayscale"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Embers.light.yml" ]; then
        sed -i 's/^colorscheme.*/colorscheme corvine_light/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="Atelier_HeathLight"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Github" ]; then
        sed -i 's/^colorscheme.*/colorscheme github/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="github"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "GoogleLight (Gogh)" ]; then
        sed -i 's/^colorscheme.*/colorscheme base16-google-light/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="base16-google-light"/' ${HOME}/.vim/configs/theme.vim
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

    if [ "$vim_theme" == "Belafonte Day" ]; then
        sed -i 's/^colorscheme.*/colorscheme Atelier_DuneLight/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="Atelier_DuneLight"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Atelierforest.dark.yml" ]; then
        sed -i 's/^colorscheme.*/colorscheme Atelier_ForestDark/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="Atelier_ForestDark"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Atelierseaside (light) (terminal.sexy)" ]; then
        sed -i 's/^colorscheme.*/colorscheme Atelier_SeasideLight/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="Atelier_SeasideLight"/' ${HOME}/.vim/configs/theme.vim
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

    if [ "$vim_theme" == "Catppuccin Latte" ]; then
        echo 'let g:catppuccin_flavour = "latte"' >> ${HOME}/.vim/configs/theme_config.vim
        sed -i 's/^colorscheme.*/colorscheme catppuccin-latte/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="catppuccin-latte"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Catppuccin Mocha" ]; then
        echo 'let g:catppuccin_flavour = "mocha"' >> ${HOME}/.vim/configs/theme_config.vim
        sed -i 's/^colorscheme.*/colorscheme catppuccin-mocha/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="catppuccin-mocha"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Catppuccin Macchiato" ]; then
        echo 'let g:catppuccin_flavour = "macchiato"' >> ${HOME}/.vim/configs/theme_config.vim
        sed -i 's/^colorscheme.*/colorscheme catppuccin-macchiato/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="catppuccin-macchiato"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    fi

    if [ "$vim_theme" == "Catppuccin Frappe" ]; then
        echo 'let g:catppuccin_flavour = "frappe"' >> ${HOME}/.vim/configs/theme_config.vim
        sed -i 's/^colorscheme.*/colorscheme catppuccin/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/airline_theme.*/airline_theme="catppuccin"/' ${HOME}/.vim/configs/theme.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    fi
fi
