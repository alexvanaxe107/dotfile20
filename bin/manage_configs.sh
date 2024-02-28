#!/usr/bin/env bash
# Arquivo para gerenciar minhas configuracoes

clean_config_files() {
    files="$(cd ~/configs/ && find ./ -type f)"
    files="${files//\.\//~/}"
    diff_files=""

    echo "The files below are changed on your config:"
    echo
    while IFS= read -r file; do
        rm "$file"
    done <<< "$files" 
}

install_link_config(){
    files="$(find ~/configs/ -type f)"
    files_configs="${files//\.\//~/}"
    diff_files=""

    echo "The files below are changed on your config:"
    echo
    while IFS= read -r file; do
        file_ln="$(sed "s/configs\///" <<< "${file}")"
        mkdir -p $(dirname $file_ln)
        ln -s "$file" "$file_ln"
    done <<< "$files_configs" 
}

apply_patch(){
    echo "No patch at the moment to aply"
}

install_stow_config(){
    stow --no-folding -d $HOME/.nix-profile/share/configs -t $HOME .
}

purge_stow_config(){
    stow -D -d $HOME/.nix-profile/share/configs -t $HOME .
}

show_help() {
    echo "Manage the config files"
    echo "c                   Clean the config files managed by nixos"
    echo "i                   Install the config files managed by nixos using stow"
    echo "p                   purge the config files managed by nixos using stow"
    echo "l                   Install the configs using symlinks instead of stow"
    echo "a                   Apply some required manual intervention"
}

req_command=""
multiply=""

while getopts "h?cipla" opt; do
    case "${opt}" in
        h|\?) req_command="h" ;;
        c) req_command="c";;
        i) req_command="i";;
        l) req_command="l";;
        p) req_command="p";;
        a) req_command="a";;
    esac
done

shift $((OPTIND-1))

case "${req_command}" in
    "h") show_help;;
    "c") clean_config_files;;
    "i") install_stow_config;;
    "l") install_link_config;;
    "p") purge_stow_config;;
    "a") apply_patch;;
    *) show_help;;
esac


