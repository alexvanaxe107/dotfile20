#!/usr/bin/env bash
files="$(find $HOME/configs/ -type f)"
files="${files//$HOME\/configs\//}"
diff_files=""

echo "The files below are changed on your config:"
echo
while IFS= read -r file; do
    result=$(diff "$HOME/configs/$file" "$HOME/$file" )
    if [ ! -z "$result" ];then
        echo $file
        diff_files=$(echo -e "$file\n$diff_files")
    fi
done <<< "$files" 

echo
echo "What do you want to do?"
option=$(echo -e "update\noverdide\nvimdiff\nviewdiffs" | fzf --height 30%)

if [ "${option}" == "vimdiff" ]; then
    while IFS= read -r file; do
        nvim -d $HOME/configs/$file $HOME/$file
    done <<< "$diff_files" 
fi

