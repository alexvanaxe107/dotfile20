#!/usr/bin/env bash
umask 022 # NIX_PROFILE_DIR="$NIX_USER_PROFILE_DIR/profile"
files="$(find $HOME/configs/ -type f)"
files="${files//$HOME\/configs\//}"
diff_files=""

echo "The files below are changed on your config:"
echo
while IFS= read -r file; do
    result=$(diff -Npur "$HOME/configs/$file" "$HOME/$file" )
    if [ ! -z "$result" ];then
        echo $file
        diff_files=$(echo -e "$file\n$diff_files")
    fi
done <<< "$files" 

echo
echo "What do you want to do?"
option=$(echo -e "override\nvimdiff" | fzf --height 20%)

if [ "${option}" == "vimdiff" ]; then
    while IFS= read -r file; do
        nvim -d $HOME/configs/$file $HOME/$file
    done <<< "$diff_files" 
fi

if [ "${option}" == "override" ]; then
    while IFS= read -r file; do
    doit=$(echo -e "yes\nno" | fzf --height 20% --prompt "Wanna update $file?")
    if [ "$doit" == "yes" ]; then
        cp --no-preserve=all $HOME/configs/$file $HOME/$file
    fi
    done <<< "$diff_files" 
fi

