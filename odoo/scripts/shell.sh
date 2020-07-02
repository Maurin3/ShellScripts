#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

odoo_dir=$ODOO_PATH/odoo
enterprise=$ODOO_PATH/enterprise
design_themes=$ODOO_PATH/design-themes

[[ ! "$2" =~ ^- ]] && addons="$2"

args="${@:3}"
[[ "$2" =~ ^- ]] && args="${@:2}"

current_dir=$PWD

free_port= `check_free_port`

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

if [[ $free_port = 0 ]]; then
    error "There is no port available..."
    exit 1
fi

cd $ODOO_PATH/odoo
branch=$(git symbolic-ref --short HEAD)

cd $current_dir
sql="SELECT latest_version FROM ir_module_module WHERE name='base'"
version=`psql -t -A -c "$sql" $1 2> /dev/null`
version=${version%.*.*}

if [[ $version == *"saas"* ]]; then
    version=${version#saas~}
    version="saas-${version}"
fi

if [[ $branch != $version ]]; then
    error "The versions between Odoo and the database are not the same. (Branch: $branch - Database: $version)"
    exit 1
fi

info "Launching Odoo on port $free_port"
if [[ -f $ODOO_PATH/odoo/odoo-bin ]]; then 
    odoo_command=$ODOO_PATH/odoo/odoo-bin
else
    odoo_command=$ODOO_PATH/odoo/odoo.py
fi
check_version=${version%.*}
if [[ $check_version -lt 11 ]]; then
    port="--xmlrpc-port $free_port"
else
    port="--http-port $free_port"
fi
if [[ $addons ]]; then
    $odoo_command shell --addons-path=$ODOO_PATH/odoo/addons,$ODOO_PATH/enterprise,$ODOO_PATH/design-themes,$addons $port -d $1 --db-filter=$1 $args
else
    $odoo_command shell --addons-path=$ODOO_PATH/odoo/addons,$ODOO_PATH/enterprise,$ODOO_PATH/design-themes $port -d $1 --db-filter=$1 $args
fi

complete