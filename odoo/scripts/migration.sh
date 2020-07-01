#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"


function createSymlink() {
    info "Creating Symbolic Link from Saas-migration repository to Odoo base add-on"

    current_dir=$PWD
    t_dir=$ODOO_PATH/odoo/odoo/addons/base/maintenance
    t_link=$ODOO_PATH/odoo/odoo/addons/base/maintenance/util.py

    cd $ODOO_PATH/odoo

    if [[ -d ${t_dir} ]]; then
        error "Directory already exists..."
    else
        warning "Directory doesn't exist..."
        info "Creating directory..."
        mkdir $ODOO_PATH/odoo/odoo/addons/base/maintenance
    fi

    if [ -L ${t_link} ]; then
        error "Symbolic link already exists..."
        exit 1
    fi

    warning "Symbolic link doesn't exist..."
    info "Creating symbolic link..."

    if [ ! $MIG_SCRIPTS ]; then
        MIG_SCRIPTS=$ODOO_PATH/saas-migration
    fi

    # $MIG_SCRIPTS=saas-migration repo
    ln -s $MIG_SCRIPTS/migrations/* $ODOO_PATH/odoo/odoo/addons/base/maintenance

    cd ${current_dir}
}

function runOld() {
    odoo_dir=$ODOO_PATH/odoo2
    if [[ ! -d $ODOO_PATH/odoo2 ]]; then
        warning "2nd Repository of Odoo Community doesn't exist..."
        warning "Clone a 2nd time Odoo Community repository by naming it 'odoo2' on the same level as the 1st."
        info "The command is : git clone git@github.com:odoo/odoo.git odoo2"
    fi
    enterprise=$ODOO_PATH/enterprise2
    if [[ ! -d $ODOO_PATH/enterprise2 ]]; then
        warning "2nd Repository of Odoo Enterprise doesn't exist..."
        warning "Clone a 2nd time Odoo Enterprise repository by naming it 'enterprise2' on the same level as the 1st."
        info "The command is : git clone git@github.com:odoo/enterprise.git enterprise2"
    fi
    design_themes=$ODOO_PATH/design-themes2
    if [[ ! -d $ODOO_PATH/design-themes2 ]]; then
        warning "2nd Repository of Odoo Themes doesn't exist..."
        warning "Clone a 2nd time Odoo Themes repository by naming it 'design-themes2' on the same level as the 1st."
        info "The command is : git clone git@github.com:odoo/design-themes.git design-themes2"
    fi

    if [[ `db_exists $1` != true ]]; then
        error "The database does not exist..."
        exit 1
    fi

    [[ ! "$2" =~ ^- ]] && addons="$2"

    args="${@:3}"
    [[ "$2" =~ ^- ]] && args="${@:2}"

    current_dir=$PWD

    port_list=(8069 8089 8099)
    free_port=0
    for port in ${port_list[@]} ; do
        lines=$(lsof -i:$port | wc -l)
        if [[ $lines = 0 ]]; then
            free_port=$port
            break
        fi
    done

    if [[ $free_port = 0 ]]; then
        error "There is no port available in the list: 8069 8089 8099"
        exit 1
    fi
    cd $ODOO_PATH/odoo2
    branch=$(git symbolic-ref --short HEAD)

    cd $current_dir
    sql="SELECT latest_version FROM ir_module_module WHERE name='base'"
    version=`psql -t -A -c "$sql" $1 2> /dev/null`
    echo "$version"
    version=${version%.*.*}
    echo "$version"

    if [[ $version == *"saas"* ]]; then
        version=${version#*.saas~}
        echo "$version"
        version="saas-${version}"
        echo "$version"
    fi

    if [[ $branch != $version && -n $version ]]; then
        error "The versions between Odoo and the database are not the same. (Branch: $branch - Database: $version)"
        exit 1
    fi

    info "Launching Odoo on port $free_port"
    addons_list="$ODOO_PATH/odoo/addons,$ODOO_PATH/enterprise,$ODOO_PATH/design-themes"
    if [[ -f $ODOO_PATH/odoo2/odoo-bin ]]; then 
        odoo_command=$ODOO_PATH/odoo2/odoo-bin
        if [[ -d $ODOO_PATH/odoo_utils ]]; then
            addons_list="${addons_list},$ODOO_PATH/odoo_utils"
        fi
    else
        odoo_command=$ODOO_PATH/odoo2/odoo.py
    fi
    check_version=${version%.*}
    if [[ $check_version -lt 11 ]]; then
        port="--xmlrpc-port $free_port"
    else
        port="--http-port $free_port"
    fi

    if [[ $addons ]]; then
        addons_list="${addons_list},$addons"
    fi

    $odoo_command --addons-path=$addons_list $port -d $1 --db-filter=$1 $args
}

args=${@:2}

case $1 in
    symlink|sym)
        createSymlink
        ;;
    run|rn)
        runOld $args
        ;;
    *)
        error "Unrecognized command: $0 $1"
        ;;
esac

complete