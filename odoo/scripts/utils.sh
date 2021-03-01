#!/usr/bin/env bash

# Colors codes
NC="\033[0m"
LIGHT_GREEN="\033[38;5;106m"
RED="\033[38;5;160m"

declare -A clr
clr=(
    [warning]="\033[38;5;208m"
    [error]="\033[38;5;160m"
    [info]="\033[38;5;106m"
    [question]="\033[38;5;039m"
)

declare -A sym
sym=(
    [warning]="!"
    [error]="!"
    [info]="i"
    [question]="?"
)

declare -A modes
modes=(
    [norm]="\033[0m"
    [bold]="\033[1m"
)

function success() {
    echo "`message success ${@:1}`"
}

# Prints a warning message
function warning() {
    echo "`message warning ${@:1}`"
}

# Prints an error message
function error() {
    echo "`message error ${@:1}`"
}

# Prints an informative message
function info() {
    echo "`message info ${@:1}`"
}

# Asks a question
function question() {
    echo "`message question ${@:1}`"
}

# Prints a string prefixed with tabs
function aligned() {
    echo -e "    ${@:1}"
}

function message() {
    if [[ -n $1 && -n $2 ]]; then
        echo -e "${modes[bold]}${clr[$1]}[${sym[$1]}]${modes[norm]} ${@:2}"
    else
        echo "Invalid use of \`message()\`"
    fi
}

function confirm() {
    msg="$1"

    if [[ -z "$msg" ]]; then
        msg="Do you wish to continue?"
    fi

    msg="`question $msg`"
    read -p "$msg (Y/n) " confirmed

    if [[ "$confirmed" == "Y" || "$confirmed" == "y" ]]; then
        echo true
    else
        echo false
    fi
}

# Exits the program if an error occured in the last command
function exit_on_error() {
    status=$?
    if [[ $status != 0 ]]; then
        error "$1"
        exit $status
    fi
}

function complete() {
    msg=$1

    if [[ -z $1 ]]; then
        msg="Done!"
    fi

    info "$msg"
    exit 0
}

# Ask for a string from the user
function ask() {
    msg=$1

    if [[ -z "$msg" ]]; then
        msg="Login:"
    fi

    msg="`question $msg`"
    read -p "$msg " answer

    echo "$answer"
}

function db_exists() {
    if [[ `psql -lqt | cut -d \| -f 1 | grep -w $1` ]]; then
        echo true
    else
        echo false
    fi
}

function check_changes() {
    path=$1
    cmd="git -C $path diff-index --quiet HEAD"
    $cmd
    status=$?
    if [[ $status == 0 ]]; then
        echo true
    else
        echo false
    fi
}

function check_free_port(){
    port_list=(8069 8079 8089 8099 9069 9079 9089 9099)
    free_port=0
    for port in ${port_list[@]} ; do
        lines=$(lsof -i:$port | wc -l)
        if [[ $lines = 0 ]]; then
            free_port=$port
            break
        fi
    done
    echo "$free_port"
}
