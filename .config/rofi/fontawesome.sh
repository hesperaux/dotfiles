options='-columns 4 -width 200 -lines 10 -bw 2 '
#-yoffset -2 -location 1'

selected=$(\
  cat ~/.config/rofi/icon-list.txt \
    | rofi -dmenu -i -markup-rows \
    ${options} -p "Select icon: ")

# exit if nothing is selected
[[ -z $selected ]] && exit

echo -ne $(echo "$selected" |\
  awk -F';' -v RS='>' '
    NR==2{sub("&#x","",$1);print "\\u" $1;exit}'
) |  xclip 
#-selection clipboard
