#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

odoo_dir=$ODOO_PATH/odoo
current_dir=$PWD

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

if [[ `is_running $1` == false ]]; then
    error "The database $1 is not running"
    exit 1
fi

if [[ -z $2 ]]; then
    error "There is nothing to deploy on the database $1"
fi

if [[ ! $2 ]]; then 
    error "There is nothing to deploy. Check you command..."
    exit 1
else
    info "Deploying module to Odoo on database $1"
    odoo_dir=$ODOO_PATH/odoo
    if [[ -f $odoo_dir/odoo-bin ]]; then 
        odoo_command=$odoo_dir/odoo-bin
    else
        odoo_command=$odoo_dir/odoo.py
    fi
    $odoo_command deploy $2 --db $1
fi

complete