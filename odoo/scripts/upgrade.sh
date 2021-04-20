#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"
source "$DIR/migration.sh"

odoo_dir=$ODOO_PATH/odoo
enterprise=$ODOO_PATH/enterprise
design_themes=$ODOO_PATH/design-themes

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

[[ ! "$2" =~ ^- ]] && addons="$2"

args="${@:3}"
[[ "$2" =~ ^- ]] && args="${@:2}"

current_dir=$PWD

free_port=$(check_free_port)

if [[ $free_port = 0 ]]; then
    error "There is no port available..."
    exit 1
fi

cd $odoo_dir
branch=$(git symbolic-ref --short HEAD)

cd $current_dir
sql="SELECT latest_version FROM ir_module_module WHERE name='base'"
version=`psql -t -A -c "$sql" $1 2> /dev/null`
version=${version%.*.*}

if [[ $version == *"saas"* ]]; then
    version=${version#*.saas~}
    version="saas-${version}"
fi

if [[ $branch != $version && -n $version ]]; then
    error "The versions between Odoo and the database are not the same. (Branch: $branch - Database: $version)"
    exit 1
fi

addons_list="$odoo_dir/addons,$enterprise,$design_themes"
if [[ -f $odoo_dir/odoo-bin ]]; then 
    odoo_command=$odoo_dir/odoo-bin
    if [[ -d $ODOO_PATH/odoo_utils ]]; then
        addons_list="${addons_list},$ODOO_PATH/odoo_utils"
    fi
else
    odoo_command=$odoo_dir/odoo.py
fi
check_version=${version%.*}
if [[ $check_version -lt 11 ]]; then
    port="--xmlrpc-port=$free_port"
else
    port="--http-port=$free_port"
fi

symlink=0
if [[ $check_version -lt 13 ]]; then
    create_symlink
    upg_path=""
else
    std_upg_path=$ODOO_PATH/upgrade/migrations
    custom_upg_path=$ODOO_PATH/psbe-custom-upgrade/migrations
    upg_path="--upgrade-path=${std_upg_path},${custom_upg_path}"
fi

if [[ $addons ]]; then
    if [[ -d $addons && -d $addons/psbe-internal ]]; then
        addons_list="${addons_list},$addons/psbe-internal"
    fi
    addons_list="${addons_list},$addons"
fi

info "Launching Odoo's upgrade on port $free_port"
$odoo_command --addons-path=$addons_list $port -d $1 --db-filter=^$1$ $args --limit-time-cpu=10000000 --limit-time-real=1000000 --stop-after-init $upg_path
