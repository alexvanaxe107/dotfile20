#!/usr/bin/env bash

clean_config_files() {
    files="$(find ~/configs/ -type f)"
    #files="${files//\.\/share\/configs\//}"
    diff_files=""

    echo "The files below are changed on your config:"
    echo
    while IFS= read -r file; do
        #mkdir -p $(dirname /home/alexvanaxe/config_bkp/${file})
        rm "$file"
    done <<< "$files" 
}

install_stow_config(){
    stow -d /home/alexvanaxe/.nix-profile/share/configs -t /home/alexvanaxe/ .
}

show_help() {
    echo "Manage the config files"
    echo "c                   Clean the config files managed by nixos"
    echo "i                   Install the config files managed by nixos using stow"
}

req_command=""
multiply=""

while getopts "h?ci" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        c) req_command="c";;
        i) req_command="i";;
    esac
done

shift $((OPTIND-1))

case "${req_command}" in
    "c") clean_config_files;;
    "i") install_stow_config;;
    *) show_help;;
esac


