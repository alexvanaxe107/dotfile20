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

install_stow_config(){
    stow -d /home/alexvanaxe/.nix-profile/share/configs -t /home/alexvanaxe/ .
}

purge_stow_config(){
    stow -D -d /home/alexvanaxe/.nix-profile/share/configs -t /home/alexvanaxe/ .
}

show_help() {
    echo "Manage the config files"
    echo "c                   Clean the config files managed by nixos"
    echo "i                   Install the config files managed by nixos using stow"
    echo "p                   purge the config files managed by nixos using stow"
}

req_command=""
multiply=""

while getopts "h?cip" opt; do
    case "${opt}" in
        h|\?) req_command="h" ;;
        c) req_command="c";;
        i) req_command="i";;
        p) req_command="p";;
    esac
done

shift $((OPTIND-1))

case "${req_command}" in
    "h") show_help;;
    "c") clean_config_files;;
    "i") install_stow_config;;
    "p") purge_stow_config;;
    *) show_help;;
esac


