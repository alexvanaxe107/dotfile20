#! /bin/sh
#! /bin/sh

set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail

echo "Iniciando teste"

option="$(youtube-dl --list-formats "https://www.youtube.com/watch?v=det3U5eqGb8" | sed -n '6,$p')"

chosen_p=$(basename -a "${OPTIONS}" | dmenu  -l 10 -i -p "Select the player:")

awk '{print $1}' <<< ${chosen_p}

