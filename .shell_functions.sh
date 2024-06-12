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

awsp() {
    if [ -z "${1}" ]; then
        echo "Setting profile to 'rfideas-dev'"
        export AWS_PROFILE="rfideas-dev"
    else {
        echo "Setting profile to '${1}'"
        export AWS_PROFILE="${1}"
    }
    fi
}

awsr() {
    if [ -z "${1}" ]; then
        echo "Setting region to 'us-west-2'"
        export AWS_REGION="us-west-2"
        return;
    else {
        echo "Setting region to '${1}'"
        export AWS_REGION="${1}"
    }
    fi

}
