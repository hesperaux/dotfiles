#!/usr/bin/env bash
theme="$HOME/.config/rofi/nerdfonts.rasi"

# if argument is passed, use it as csv, otherwise, look for file relative to dir
[ $# -eq 0 ] && {
    # get location of chars.csv relative to script
    chars_csv="$(dirname $0)/chars.csv"
} || {
    chars_csv="${1}"
}
# if csv file does not exist, error and exit
[ ! -f "${chars_csv}" ] && { echo "${chars_csv} is not a valid file" >&2; exit 1; }

# read in lines from code.csv into array
readarray chars < "${chars_csv}"

# print all codes and names (replacing command with space) and select using rofi
char_entry=$(
    for char in "${chars[@]}";{
        echo ${char/,/ }
    }|rofi -show -dmenu -theme ${theme}
)

# If user cancelled rofi, exit
[ -z "${char_entry}" ] && exit

# get char from line
char="${char_entry% *}"
# get codepoint from char (needed for xdotool)
codepoint=U$(printf %x\\n \'"${char}")
# use xdotool to enter character
#xdotool key "${codepoint}"
echo $char | tr -d '\n' | xclip -selection primary
