#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

current_dir=$PWD

if [[ $# -gt 1 ]]; then
    error "Illegal number of parameters"
    exit 1
fi

if [[ $is_from_mig = 0 ]]; then
    odoo_dir=$ODOO_PATH/odoo
    enterprise=$ODOO_PATH/enterprise
    design_themes=$ODOO_PATH/design-themes
else
    odoo_dir=$ODOO_PATH/odoo2
    enterprise=$ODOO_PATH/enterprise2
    design_themes=$ODOO_PATH/design-themes2
fi

cd $odoo_dir

if [[ $# = 0 ]]; then
    branch=$(git symbolic-ref --short HEAD)
    info "Odoo version: $branch"
    cd $current_dir
    exit 0
fi

info "This operation can take some time. (Odoo Community repository has a great number of commits)"

if [[ `check_changes` == false ]]; then
    error "Odoo Community : There are uncommited changes... Please reset your branch or stash the changes."
    exit 1
fi
git checkout -q $1
git pull -q
git clean -dfxq
branch=$(git symbolic-ref --short HEAD)
info "Odoo Community version is now $branch"

cd $enterprise

if [[ `check_changes` == false ]]; then
    error "Odoo Enterprise : There are uncommited changes... Please reset your branch or stash the changes."
    exit 1
fi
git checkout -q $1
git pull -q
git clean -dfxq
branch=$(git symbolic-ref --short HEAD)
info "Odoo Enterprise version is now $branch"

cd $design_themes

if [[ `check_changes` == false ]]; then
    error "Odoo Themes : There are uncommited changes... Please reset your branch or stash the changes."
    exit 1
fi
git checkout -q $1
git pull -q
git clean -dfxq
branch=$(git symbolic-ref --short HEAD)
info "Odoo Themes is now $branch"
cd $current_dir

complete