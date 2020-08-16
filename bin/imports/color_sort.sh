#! /bin/sh

# Exit on error. Append "|| true" if you expect an error.
# Exit on error inside any functions or subshells.
# set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
# set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
# set -o pipefail

#colors=($(convert "./wallhaven-96w8e8_1440x900.png" -format %c -depth 6 -colors 20 histogram:info:- | sort -n | grep -o "#......" | cut -d "#" -f 2))


colorToLum() {
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

order_list() {
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

black_or_white() {
    colors=$1

    index=$2
    
    local colors_abc=($(order_list $colors))
    lums=($(echo -e ${colors_abc[@]}  | sort -n | awk '{print $1}' | cut -d "#" -f 2))

    lum=${lums[$index]}
    echo ${lum} > ~/debug.txt
    if (( $(echo "$lum  > 133" |bc -l) )); then
        echo black
    fi
    if (( $(echo "$lum  <= 133" |bc -l) )); then
        echo light
    fi
}

get_sorted_color() {
    local colors_lum=($(order_list $1))
    echo -e ${colors_lum[@]}  | sort -n | awk '{print $2}' | cut -d "#" -f 2
}
