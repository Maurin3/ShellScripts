#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

if [[ $# -ne 1 ]]; then
    error "Illegal number of parameters"
    exit 1
fi

if [[ `db_exists $1` == true ]]; then
    error "The database already exists..."
    exit 1
fi

createdb $1

complete
