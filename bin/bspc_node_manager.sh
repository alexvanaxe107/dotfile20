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

    if [ ! -z "${window}" ]; then
        bspc node ${window} -g hidden
        bspc node ${window} --focus
    fi
}

mark_node() {
    . $HOME/.config/bspwm/themes/bsp.cfg

    node=$1

    if [ -z "${node}" ]; then
        node=`bspc query -N -n focused`
    fi
    bspc node ${node} -g marked

    is_marked=$(bspc query -N -n ${node}.marked)

    if [ ! -z "${is_marked}" ]; then
        bspc config -n ${node} border_width 5
    else
        bspc config -n ${node} border_width 1
    fi
}

retrieve_marked_node (){
    marked=`bspc query -N -n .marked | head -n 1`
    empty=`bspc query -N -n .leaf.!window`

    if [ -z "$marked" ];then
        exit 0
    fi
    if [ -z "${empty}" ]; then
        bspc node -s "$marked"
        mark_node ${marked}
        bspc node ${marked} -f
    else
        bspc node ${marked} -n ${empty}
        mark_node ${marked}
        bspc node ${marked} -f
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


while getopts "h?bmiIg" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        b) bring_program;;
        m) mark_node;;
        i) hide_node;;
        g) retrieve_marked_node;;
        I) show_hidden_pile;;
    esac
done
