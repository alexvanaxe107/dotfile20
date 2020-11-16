#!/bin/dash
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
id_only=0



show_help() {
    echo "Get monitor information."
    echo ""
    echo "-m             Get a list with the monitors name (primary first)"
    echo "-p             Show the primary monitor name"
    echo "-i             Show the selected monitor id (ip)"
    echo "-n {id}        Get name by id"
    echo "-in {name}     Get name by id"
}

print_primary_information() {
    if [ ${id_only} -eq 0 ]; then
        xrandr --listmonitors | awk 'NR==2 {print $1$2}' | cut -d "*" -f 2
    else
        xrandr --listmonitors | awk 'NR==2 {print $1$2}' | cut -d ":" -f 1
    fi
}

name_by_id(){
    if [ ${id_only} -eq 0 ]; then
        m_id=$(($1+2))
        xrandr --listmonitors | awk -v ID=$m_id  'NR==ID {print $1$2}' | cut -d ":" -f 2 | grep -Po "[a-zA-Z0-9]*"
    else
        xrandr --listmonitors | awk 'NR>1 {print $1$2}' | grep -i $1 | cut -d : -f 1
    fi
}

monitors_information() { 
    if [ ${id_only} -eq 0 ]; then
        xrandr --listmonitors | awk 'NR>1 {print $1$2}' | cut -d ":" -f 2 | grep -Po "[a-zA-Z0-9]*"
    else
        xrandr --listmonitors | awk 'NR>1 {print $1$2}' | cut -d ":" -f 1
    fi
}

while getopts "h?mpin:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    i)  id_only=1
        ;;
    m)  monitors_information
        ;;
    p)  print_primary_information
        ;;
    n)  name_by_id $OPTARG
        ;;
    esac
done
shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift
