#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

current_dir=$PWD
if [[ $# -gt 0 ]]; then
    error "Illegal number of parameters"
    exit 1
fi

cd $ODOO_PATH/odoo
if [[ `check_changes` == true ]]; then
    info "No changes in Odoo repository"
else
    git reset -q --hard
    git clean -dfxq
    info "Odoo repository has been reset"
fi

cd $ODOO_PATH/enterprise
if [[ `check_changes` == true ]]; then
    info "No changes in Odoo Enterprise repository"
else
    git reset -q --hard
    git clean -dfxq
    info "Odoo Enterprise repository has been reset"
fi

cd $ODOO_PATH/design-themes
if [[ `check_changes` == true ]]; then
    info "No changes in Odoo Themes repository"
else
    git reset -q --hard
    git clean -dfxq
    info "Odoo Themes repository has been reset"
fi

cd $current_dir

complete