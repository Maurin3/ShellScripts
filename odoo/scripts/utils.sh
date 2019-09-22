#!/usr/bin/env bash

# Colors codes
NC="\033[0m"

WHITE="\033[1;37m"
BLACK="\033[0;30m"
BLUE="\033[0;34m"
LIGHT_BLUE="\033[1;34m"
GREEN="\033[0;32m"
LIGHT_GREEN="\033[1;32m"
CYAN="\033[0;36m"
LIGHT_CYAN="\033[1;36m"
RED="\033[0;31m"
LIGHT_RED="\033[1;31m"
PURPLE="\033[0;35m"
LIGHT_PURPLE="\033[1;35m"
YELLOW="\033[1;33m"
ORANGE="\033[0;33m"
GRAY="\033[0;30m"
LIGHT_GRAY="\033[0;37m"

# Layout messages
function warning() {
    echo -e "${ORANGE}[!]${NC} ${@:1}"
}

function info() {
    echo -e "${LIGHT_GREEN}[i]${NC} ${@:1}"
}

function error() {
    echo -e "${LIGHT_RED}[!]${NC} ${@:1}"
}

function question() {
    echo -e "${LIGHT_BLUE}[?]${NC} ${@:1}"
}

# Prints a string prefixed with tabs
function aligned() {
  echo -e "    ${@:1}"
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
    cmd="git diff-index --quiet HEAD"
    $cmd
    status=$?
    if [[ $status == 0 ]]; then
        echo true
    else
        echo false
    fi
}

function is_running() {
    pid=`ps aux | grep -E "odoo-bin.*-d\s$1" | awk '{print $2}'`
    if [[ -n "$pid" ]]; then
        echo "$pid"
    else
        echo false
    fi
}