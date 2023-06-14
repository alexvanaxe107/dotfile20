#! /bin/bash

PERCENT=unset
USED=unset
TOTAL=unset
JSON=unset

usage()
{
  echo "Usage: mem.sh [ -p | --percent ]"
  echo "              [ -u | --used ]"
  echo "              [ -t | --total ]"
  echo "              [ -j | --json ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n mem.sh -o putj --long percent,used,total,json -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

#echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -a | --percent)   PERCENT=1      ; shift   ;;
    -u | --used)   USED=1      ; shift   ;;
    -t | --total)   TOTAL=1      ; shift   ;;
    -j | --json)   JSON=1      ; shift   ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

percent(){
  local mem_per="$(free -m | awk '/Mem/ {printf "%.2f", $3/$2*100 }')"
  echo "$mem_per"
}

used(){
  local mem=`free | awk '/Mem/ {printf "%f", $3 / 1048576}'`
  echo "$mem"
}

total(){
  local total=`free | awk '/Mem/ {printf "%f", $2 / 1048576}'`
  echo "$total"
}

json(){
  local mem_per="$(free -m | awk '/Mem/ {printf "%.2f", $3/$2*100 }')"
  local mem=`free | awk '/Mem/ {printf "%f", $3 / 1048576}'`
  local total=`free | awk '/Mem/ {printf "%f", $2 / 1048576}'`

  echo "{\"total\": $total, \"used\": $mem, \"percent\": $mem_per}"
}

if [ $PERCENT == 1 ]; then
    echo $(percent)
fi

if [ $USED == 1 ]; then
    echo $(used)
fi

if [ $TOTAL == 1 ]; then
    echo $(total)
fi

if [ $JSON == 1 ]; then
    echo $(json)
fi

exit 0

mem(){
  mem_per="$(free -m | awk '/Mem/ {printf "%.2f", $3/$2*100 }')"
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo "$mem ($mem_per)%"
}

mem
