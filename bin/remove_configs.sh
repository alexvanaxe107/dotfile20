#!/usr/bin/env bash
files="$(find ~/configs/ -type f)"
#files="${files//\.\/share\/configs\//}"
diff_files=""

echo "The files below are changed on your config:"
echo
while IFS= read -r file; do
    #mkdir -p $(dirname /home/alexvanaxe/config_bkp/${file})
    rm "$file"
done <<< "$files" 
