#
#!/usr/bin/env bash

# Current Theme
theme="$HOME/.config/rofi/displays.rasi"

# Options
internal=''
double=' '
triple='  '
quad='   '
cancel='ﰸ'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu -theme ${theme}
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${theme}
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo "$internal\n$double\n$triple\n$quad\n$cancel" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
            if [[ $1 == '--internal' ]]; then
                    ${HOME}/.screenlayout/1screen.sh
            elif [[ $1 == '--double' ]]; then
                    ${HOME}/.screenlayout/2screens.sh
            elif [[ $1 == '--triple' ]]; then
                    ${HOME}/.screenlayout/3screens.sh
            elif [[ $1 == '--quad' ]]; then
                    ${HOME}/.screenlayout/4screens.sh
            fi
	else
            exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $internal)
        run_cmd --internal
        ;;
    $double)
        run_cmd --double
        ;;
    $triple)
        run_cmd --triple
        ;;
    $quad)
        run_cmd --quad
        ;;
    $cancel)
        exit 0
esac
