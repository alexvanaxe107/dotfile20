#!/usr/usr/bin/env bash

#Clock(){
	#TIME=$(date "+%H:%M:%S")
	#echo -e -n " \uf017 ${TIME}" 
#}

#Cal() {
    #DATE=$(date "+%a, %m %B %Y")
    #echo -e -n "\uf073 ${DATE}"
#}

Load() {
    LOAD=$(load)
    echo -e -n "\uf073 ${LOAD}"
}

Cpu() {
    CPU=$(cpu.sh)
    echo -e -n "\uf073 ${CPU}"
}

while true; do
    echo -e "$(Load) $(Cpu)"
	sleep 1
done
