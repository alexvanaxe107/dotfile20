#! /bin/sh

number=$1
re="^[0-9]+$"

if  [ $(echo "$number" | grep -E $re) ]; then
    echo "number"
else
    echo "not number"
fi
