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

info "Creating $2 database based on $1 database..."
createdb -T $1 $2
if [[ -d $HOME/.local/share/Odoo/filestore/$1 ]]; then
    info "There is a filestore linked to the database $1."
    if [[ `confirm "Do you wish to copy the filestore?"` = true ]]; then
        mkdir $HOME/.local/share/Odoo/filestore/$2
        cp -r $HOME/.local/share/Odoo/filestore/$1/* $HOME/.local/share/Odoo/filestore/$2
        info "Filestore copied"
    else
        warning "Not copying the filestore (User's will)."
    fi
else
    warning "Not copying the filestore since the filestore of the database $1 does not exist"
fi

complete
