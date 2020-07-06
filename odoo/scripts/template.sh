#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

if [[ $# -ne 2 ]]; then
    error "Illegal number of parameters"
    exit 1
fi

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

if [[ `db_exists $2` = true ]]; then
    error "The database already exists..."
    exit 1
fi

if [[ -d $HOME/.local/share/Odoo/filestore/$1 ]]; then
    info "There is a filestore linked to the database $1."
    if [[ `confirm "Do you wish to copy the filestore?"` = true ]]; then
        if [[ ! -d $HOME/.local/share/Odoo/filestore/$2 ]]; then
            mkdir $HOME/.local/share/Odoo/filestore/$2
        fi
        if find $HOME/.local/share/Odoo/filestore/$1/ -mindepth 1 | read; then
            cp -r $HOME/.local/share/Odoo/filestore/$1/* $HOME/.local/share/Odoo/filestore/$2
            info "Filestore copied"
        else
            info "Filestore not detected, no copy done..."
        fi
    else
        warning "Not copying the filestore (User's will)."
    fi
else
    warning "Not copying the filestore since the filestore of the database $1 does not exist"
fi

info "Creating $2 database based on $1 database..."
createdb -T $1 $2 &> /dev/null
exit_on_error "There is an issue while creating the database. Make sure the database $1 is not running."

complete
