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

free_port=$(check_free_port)

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

if [[ $free_port = 0 ]]; then
    error "There is no port available..."
    exit 1
fi

if [[ $is_from_mig = 0 ]]; then
    odoo_dir=$ODOO_PATH/odoo
    enterprise=$ODOO_PATH/enterprise
    design_themes=$ODOO_PATH/design-themes
else
    odoo_dir=$ODOO_PATH/odoo2
    if [[ ! -d $ODOO_PATH/odoo2 ]]; then
        warning "2nd Repository of Odoo Community doesn't exist..."
        warning "Clone a 2nd time Odoo Community repository by naming it 'odoo2' on the same level as the 1st."
        info "The command is : git clone git@github.com:odoo/odoo.git odoo2"
        exit 1
    fi
    enterprise=$ODOO_PATH/enterprise2
    if [[ ! -d $ODOO_PATH/enterprise2 ]]; then
        warning "2nd Repository of Odoo Enterprise doesn't exist..."
        warning "Clone a 2nd time Odoo Enterprise repository by naming it 'enterprise2' on the same level as the 1st."
        info "The command is : git clone git@github.com:odoo/enterprise.git enterprise2"
        exit 1
    fi
    design_themes=$ODOO_PATH/design-themes2
    if [[ ! -d $ODOO_PATH/design-themes2 ]]; then
        warning "2nd Repository of Odoo Themes doesn't exist..."
        warning "Clone a 2nd time Odoo Themes repository by naming it 'design-themes2' on the same level as the 1st."
        info "The command is : git clone git@github.com:odoo/design-themes.git design-themes2"
        exit 1
    fi
fi

cd $odoo_dir
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

if [[ $addons ]]; then
    if [[ -d $addons && -d $addons/psbe-internal ]]; then
        addons_list="${addons_list},$addons/psbe-internal"
    fi
    addons_list="${addons_list},$addons"
fi

$odoo_command shell --addons-path=$addons_list $port -d $1 --db-filter=^$1$ $args

complete
