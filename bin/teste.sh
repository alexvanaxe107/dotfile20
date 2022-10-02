#!/usr/bin/env bash

htop=$(monitors_info.sh -d | awk 'BEGIN {FS="x"} {if ($2 > TESTE) TESTE=$2;} END {print TESTE}')

optimal_rescale="$(monitors_info.sh -D)x${htop}"

printf $optimal_rescale
