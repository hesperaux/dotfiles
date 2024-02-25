PATH=${PATH}:/usr/local/bin:$HOME/.script/:/opt/ollama/
function qtilepip() {
    sudo /opt/qtile/venv/bin/pip3 "${1}" "${2}";
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

alert_timed() {
    time `sleep ${1} && notify-send "${2}"` &
}

fonts_list() {
    fc-list \
        | grep -ioE ": [^:]*$1[^:]+:" \
        | sed -E 's/(^: |:)//g' \
        | tr , \\n \
        | sort \
        | uniq
}

