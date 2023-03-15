#! /bin/dash

mem(){
  mem_per="$(free -m | awk '/Mem/ {printf "%.2f", $3/$2*100 }')"
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo "$mem ($mem_per)%"
}

mem
