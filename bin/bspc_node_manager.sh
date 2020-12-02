#! /bin/dash

show_help() {
    echo "Manipulates the notes of the bspwm" echo ""
    echo "-b             Bring the program to the current desktop"
    echo "-m             Mark the current node"
}

hide_node() {
    bspc node focused -g hidden
}

show_hidden_pile() {
    window=$(bspc query -N -n .hidden | tail -n 1)

    bspc node ${window} -g hidden
    bspc node ${window} --focus
}

mark_node() {
    . $HOME/.config/bspwm/themes/bsp.cfg

    bspc node focused -g marked
    is_marked=$(bspc query -N -n focused.marked)

    if [ ! -z "${is_marked}" ]; then
        bspc config -n focused border_width 5
    else
        bspc config -n focused border_width 1
    fi
}

retrieve_index() {
	selected=$(wmctrl -l | awk '{$1=$2=$3="";print NR $0}' | dmenu -l 10)
	index=$(echo $selected | awk '{print $1}')
	echo ${index}
}

retrieve_program() {
	index=$1
	code=$(wmctrl -l | awk -v IND=${index} 'NR==IND {print $1}')
	echo ${code}
}

focus_program() {
    indice=$(retrieve_index)
    code=$(retrieve_program $indice)
	bspc node ${code} --focus
}

bring_program() {
    indice=$(retrieve_index)
    code=$(retrieve_program $indice)
	bspc node ${code} --to-desktop focused
}

action=$1

if [ -z ${action} ]; then
    focus_program
fi


while getopts "h?bmiI" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        b) bring_program;;
        m) mark_node;;
        i) hide_node;;
        I) show_hidden_pile;;
    esac
done
