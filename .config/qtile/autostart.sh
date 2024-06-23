#!/bin/bash

bash ${HOME}/.config/qtile/host_autostart.sh
picom &
blueman-applet &
numlockx on &
${HOME}/.script/setwal.sh &
# Set GPS coordinates to Eiffel Tower
export LOCATION="48.85830:2.29448"
# Get personalized GPS info
[[ -f ${HOME}/.config/qtile/geoloc ]] && source ${HOME}/.config/qtile/geoloc
echo "Redshift location is ${LOCATION}"

redshift -l manual -m randr -l ${LOCATION} &
