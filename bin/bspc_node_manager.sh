#! /bin/dash

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
	node=$1
	bspc node $1 --focus
}

bring_program() {
	node=$1
	bspc node $1 --to-desktop focused
}

action=$1

indice=$(retrieve_index)
code=$(retrieve_program $indice)

case "${action}" in
	"-b") bring_program ${code};;
	*) focus_program ${code};;
esac

