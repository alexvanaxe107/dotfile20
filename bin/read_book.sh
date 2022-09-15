#! /bin/bash

TERMINAL="0"

read_book(){
    local indexes="$(calibredb search "$1" | tr ',' '\n')"
    local booklist=""

    for index in ${indexes}; do
        booklist="$booklist$index#$(calibredb show_metadata ${index} | awk 'NR==1 {print $2}' FS=" : ")\n"
    done

    if [ "${TERMINAL}" = "0" ]; then
        local book_to_read=$(printf "${booklist}" | dmenu -l 20)
    else
        local IFS=$'\n'
        select selected in $(printf $booklist)
        do
            book_to_read=$selected
            break
        done
    fi

    if [ -z "${book_to_read}" ]; then
        exit 0
    fi

    local selected_id=$(echo "${book_to_read}" | awk '{print $1}' FS="#")
    local bookname=$(sqlite3 /home/media/Books/metadata.db "select name,format from data where book=${selected_id};" | head -n 1)
    local book="$(echo ${bookname} | awk '{print $1}' FS="|")"
    local format="$(echo ${bookname} | awk '{print $2}' FS="|")"

    found="0"
    echo "$format"
    echo "$book"
    echo "$(find ~/../media/Books -name "${book}*.azw3" | head -n 1)"
    
  . $HOME/.pyenv/versions/wm/bin/activate
    case "$format" in
        PDF) found="1";zathura "$(find ~/../media/Books -name "${book}*.pdf" | head -n 1)" 2>&1 &;;
        AZW3) found="1";foliate "$(find ~/../media/Books -name "${book}*.azw3" | head -n 1)" 2>&1 &;;
        EPUB) found="1";foliate "$(find ~/../media/Books -name "${book}*.epub" | head -n 1)" 2>&1 &;;
        MOBI) found="1";foliate "$(find ~/../media/Books -name "${book}*.mobi")" 2>&1 &;;
        #AZW3) found="1";wezterm start epy "$(find ~/../media/Books -name "${book}*.azw3" | head -n 1)" 2>&1 &;;
        #EPUB) found="1";wezterm start epy "$(find ~/../media/Books -name "${book}*.epub" | head -n 1)" 2>&1 &;;
        #MOBI) found="1";wezterm start epy "$(find ~/../media/Books -name "${book}*.mobi")" 2>&1 &;;
    esac

    if [ "${found}" = "0" ]; then
        notify-send -u critical "Read a book" "Could not find any app to read the file of format ${format}"
    fi
}

show_help() {
    echo "Read a book."; echo ""
    echo "-b [name]                             Read a book by the name"
    echo "-t                                    Terminal only"
}

while getopts "h?tb:" opt; do
    case "$opt" in
    h|\?) show_help;;
    t) TERMINAL="1";;
    b) read_book $OPTARG;;
    esac
done

