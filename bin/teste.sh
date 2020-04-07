#! /bin/sh

VAR1="="
VAR2="teste=teste123"

source ${HOME}/.config/bspwm/themes/bsp.cfg

echo ${theme_name}

echo ${VAR2} | awk -v VAR1=${VAR1} 'BEGIN{FS=VAR1} {print $1}'

if [[ ${VAR1} != "Teste" ]]; then
    echo "Igual"
else
    echo "Nao igual"
fi
