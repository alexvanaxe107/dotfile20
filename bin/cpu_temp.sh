#! /bin/dash

cpu_temp() {
    sensors | grep -P -o "\+\d*\.\d*" | awk '{if(NR==1 || NR ==4 || NR==7) printf("%sº",$0)}'
}

cpu_temp
