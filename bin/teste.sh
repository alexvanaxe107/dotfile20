#!/bin/bash
# A basic summary of my sales report
#!/bin/bash
#counter=0

#bspc query -D --names | while read -r name; do
  #printf 'ws-icon-%i = "%s;<insert-icon-here>"\n' $((counter++)) $name
#done

apagar=0
#for arg do
    #if [[ "$arg" != "-val2" ]]; then
        #echo "$arg"
    #fi
    ##set -- "$@" "$arg"
#done
is_theme() {
    for arg do
      [ "$arg" = "-val2" ] && echo "1" && break
    done
}

echo "$(is_theme $@)"
