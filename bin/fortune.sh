#! /bin/dash

shabbat=$(date | grep -E "(Fri|Sat)")
if [ -z "$shabbat" ]; then
    fortune
else
    fortune ara
fi
