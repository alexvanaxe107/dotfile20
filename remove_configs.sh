#!/usr/bin/env bash
files="$(find ./share/configs/ -type f)"
files="${files//\.\/share\/configs\//}"
diff_files=""

echo "The files below are changed on your config:"
echo
while IFS= read -r file; do
    result=$(diff "$HOME/$file" "./share/configs/$file")
    if [ ! -z "$result" ];then
        echo $file
        diff_files=$(echo -e "$file\n$diff_files")
    fi
done <<< "$files" 

echo
echo "What do you want to do?"
option=$(echo -e "override\nvimdiff" | fzf --height 30%)

if [ "${option}" == "vimdiff" ]; then
    while IFS= read -r file; do
        nvim -d $HOME/$file ./share/configs/$file
    done <<< "$diff_files" 
fi

if [ "${option}" == "override" ]; then
    while IFS= read -r file; do
        doit=$(echo -e "yes\nno" | fzf --height 20% --prompt "Wanna update $file?")

        if [ "$doit" == "yes" ]; then
            cp $HOME/$file ./share/configs/$file
        fi
    done <<< "$diff_files" 
fi

