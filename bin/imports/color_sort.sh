#! /bin/bash

# Exit on error. Append "|| true" if you expect an error.
# Exit on error inside any functions or subshells.
# set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
# set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
# set -o pipefail

#colors=($(convert "./wallhaven-96w8e8_1440x900.png" -format %c -depth 6 -colors 20 histogram:info:- | sort -n | grep -o "#......" | cut -d "#" -f 2))

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  __i_am_main_script="0" # false

  if [[ "${__usage+x}" ]]; then
    if [[ "${BASH_SOURCE[1]}" = "${0}" ]]; then
      __i_am_main_script="1" # true
    fi

    __b3bp_external_usage="true"
    __b3bp_tmp_source_idx=1
  fi
else
  __i_am_main_script="1" # true
  [[ "${__usage+x}" ]] && unset -v __usage
  [[ "${__helptext+x}" ]] && unset -v __helptext
fi


function colorToLum() {
  red=${1:1:2}
  green=${1:3:2} 
  blue=${1:5:2} 

  red2=$(echo "obase=10; $red" | bc)
  green2=$(echo "obase=10; $green" | bc)
  blue2=$(echo "obase=10; $blue" | bc)

  lum=$(echo "($red2 * 0.241) + (0.691 * $green2) + (0.68 * $blue2)" | bc)

  echo "$lum"
  #return (0.299 * $red + 0.587 * $green + 0.114 * $blue);
}

function order_list() {
    colors=$1
    local count=0
    declare -A colors_lum

    for color in ${colors[@]}; do
        #echo ${color}

        colors_lum[$count]="$(colorToLum $color)     $color\n"
        count=$(( count + 1 ))
        #./generate_img.sh "#${color}" "$count"
    done

    echo ${colors_lum[@]}
}

function get_sorted_color() {
    local colors_lum=($(order_list $1))
    echo -e ${colors_lum[@]}  | sort -n | awk '{print $2}' | cut -d "#" -f 2
}
