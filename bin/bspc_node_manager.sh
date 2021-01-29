#! /bin/dash


bring_all="0"
hide_node() {
    marked_node=$(bspc query --desktop focused -N -n .leaf.marked)
    if [ -z "${marked_node}" ]; then
        bspc node focused -g hidden
    else
        for node in ${marked_node}; do
            bspc node "${node}" -g hidden --focus
        done
    fi
}

show_hidden_pile() {
    if [ "${bring_all}" = "1" ]; then
        local hidden_windows="$(bspc query --nodes -n .leaf.hidden)"

        for hid in ${hidden_windows}; do
            bspc node ${hid} -g hidden
        done

        exit 0
    fi

    marked=$(bspc query --desktop focused -N -n .leaf.marked.hidden)

    #if [ ! -z "${marked}" ]; then
        #for node in ${marked}; do
            #bspc node ${node} -g hidden
        #done
    #else
    window=$(bspc query --desktop focused -N -n .leaf.hidden | head -n 1)

    if [ ! -z "${window}" ]; then
        bspc node ${window} -g hidden
        bspc node ${window} --focus
    fi
    #fi
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

show_help() {
    echo "Manipulates the notes of the bspwm"
    echo "-b             Bring the program to the current desktop"
    echo "-m             Mark the current node"
    echo "-i             Hide the currently focused node"
    echo "-I             Show hidden pile."
    echo "-g             Retrieve marked node."
    echo "-a             Bring all programs."
}


while getopts "h?abmiIg" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        a) bring_all="1";;
        b) bring_program;;
        m) mark_node;;
        i) hide_node;;
        g) retrieve_marked_node;;
        I) show_hidden_pile;;
    esac
done
