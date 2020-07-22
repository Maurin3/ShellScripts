#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

if [[ $# -ne 1 ]]; then
    error "Illegal number of parameters"
    exit 1
fi

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

pid=`ps aux | grep -E "*.*odoo(-bin|.py).*\s-d\s$1\s.*" | awk '{print $2}'`

if [[ -n "$pid" ]]; then
    kill -s SIGINT $pid
    warning "If you're stuck (couldn't Ctrl + C), don't forget to reset your terminal."
else
    error "The database is not running... No need to kill it"
    exit 1
fi

complete