#! /bin/dash

RADIO_FILE="$HOME/.config/play_radio/config"


play_radio() {
    chosen=$(cat $HOME/.config/play_radio/config | awk '{print NR,$1}' FS="," | dmenu)
    index=$(echo $chosen | awk '{print $1}')

    radio_url=$(cat $HOME/.config/play_radio/config | awk -v IND=${index} 'NR==IND {print $2}' FS=",")

    echo ${radio_url}
}


pl_len() {
    pl_len=$(wc -l "${HOME}"/.config/tmp/yt_pl.ps | awk '{print $1}')
    echo $pl_len
}

chosen_mode=$(printf "Local\nClipboard\nClipboard Audio\nClipboard quality\n+PL\nPlay PL\nSave\nResume\nStop" | dmenu -i -p "How to play? ($(pl_len))")

case "$chosen_mode" in
    "Local") play_radio;;
    "Clipboard") play_clipboard;;
    "Clipboard quality") play_clipboard_quality;;
    "Clipboard Audio") play_clipboard_audio;;
    "+PL") add_playlist;;
    "Play PL") play_playlist;;
    "Stop") $(stop_all);;
    "Save") save_location;;
    "Resume") resume;;
    "clear") clear_playlist;;
    "replay") replay;;
    *) exit;;
esac

