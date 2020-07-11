#! /bin/dash

shabbat=$(date | grep -E "(Fri|Sat)")
if [ -z "$shabbat" ]; then
    fortune -n 600 -s
else
    fortune -n 600 -s ara
fi
