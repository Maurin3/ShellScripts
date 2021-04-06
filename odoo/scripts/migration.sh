#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

function create_symlink() {
    info "Creating Symbolic Link from Upgrade repository to Odoo base add-on"

    current_dir=$PWD

    t_link=$ODOO_PATH/odoo/odoo/addons/base/maintenance

    if [ -L ${t_link} ]; then
        error "Symbolic link already exists..."
        warning "Skipping the creation of symbolic link..."
    else
        warning "Symbolic link doesn't exist..."
        info "Creating symbolic link..."

        if [ ! $MIG_SCRIPTS ]; then
            MIG_SCRIPTS=$ODOO_PATH/upgrade
        fi

        # $MIG_SCRIPTS=upgrade (old saas-migration) repo
        cd $ODOO_PATH/odoo/odoo/addons/base
        ln -s $MIG_SCRIPTS $ODOO_PATH/odoo/odoo/addons/base/maintenance
        cd $current_dir
    fi
}

function pull() {
    info "Retrieving changes from Upgrade repository"
    if [ ! $MIG_SCRIPTS ]; then
        MIG_SCRIPTS=$ODOO_PATH/upgrade
    fi

    git -C $MIG_SCRIPTS pull --prune -q

    complete
}

is_from_mig=1

args=${@:2}

case $1 in
    symlink|sym)
        create_symlink
        complete
        ;;
    pull)
        pull
        ;;
    run|rn)
        $DIR/run.sh $args
        ;;
    version|vs)
        $DIR/version.sh $args
        ;;
    reset|res)
        $DIR/reset.sh
        ;;
    shell|sh)
        $DIR/shell.sh $args
        ;;
esac
