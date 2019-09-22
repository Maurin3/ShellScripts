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

filestore=$HOME/.local/share/Odoo/filestore/$1

if [ -d "$filestore" ]; then
    info "There is a filestore linked to this database."
    warning "Deleting the filestore is irreversible."
    if [[ `confirm` != true ]]; then
        warning "Operation aborted by user."
        exit 1
    fi
    info "Deleting database $1..."
    dropdb $1 2>/dev/null
    exit_on_error "There is an issue while deleting the database. Make sure the database is not running."
    info "Removing the filestore of $1"
    rm -rf $filestore
fi

complete