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

cur_dir=$(pwd)

if [[ -d $HOME/.local/share/Odoo/filestore/$1 ]]; then
    cd $HOME/.local/share/Odoo/filestore/$1
    nb_elements=$(ls -A | wc -l)
    cd $cur_dir
    if [ $nb_elements -lt 100 ]; then
        if [[ ! -d $HOME/.local/share/Odoo/filestore/$2 ]]; then
            mkdir $HOME/.local/share/Odoo/filestore/$2
        fi
        cp -r $HOME/.local/share/Odoo/filestore/$1/* $HOME/.local/share/Odoo/filestore/$2
    else
        info "There is a filestore linked to the database $1 ($nb_elements elements inside)."
        if [[ `confirm "Do you wish to copy the filestore?"` = true ]]; then
            if [[ ! -d $HOME/.local/share/Odoo/filestore/$2 ]]; then
                mkdir $HOME/.local/share/Odoo/filestore/$2
            fi
            cp -r $HOME/.local/share/Odoo/filestore/$1/* $HOME/.local/share/Odoo/filestore/$2
            info "Filestore copied"
        else
            warning "Not copying the filestore (User's will)."
        fi
    fi
else
    warning "Not copying the filestore since the filestore of the database $1 does not exist"
fi

info "Creating $2 database based on $1 database..."
createdb -T $1 $2 &> /dev/null
exit_on_error "There is an issue while creating the database. Make sure the database $1 is not running."

complete
