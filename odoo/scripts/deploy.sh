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

cd $ODOO_PATH/odoo
branch=$(git symbolic-ref --short HEAD)
cd $current_dir
sql="SELECT latest_version FROM ir_module_module WHERE name='base'"
version=`psql -t -A -c "$sql" $1 2> /dev/null`
version=${version%.*.*}
if [[ $branch != $version ]]; then
    error "The versions between Odoo and the database are not the same. (Odoo : $branch - Database: $version)"
    exit 1
else
    info "Deploying module to Odoo on database $1"
    if [[ ! $2 ]]; then 
        error "There is nothing to deploy. Check you command..."
        exit 1
    else
        $ODOO_PATH/odoo/odoo-bin deploy $2 --db $1
    fi
fi

complete