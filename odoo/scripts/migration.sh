#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

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

complete