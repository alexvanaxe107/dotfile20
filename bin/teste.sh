#! /bin/sh

number="⛅️ +22°C 🌘"
re="[0-9].*c"

number=$(echo $number | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')

if  [ $(echo "$number"  | grep -E $re) ]; then
    echo "number"
else
    echo "not number"
fi
