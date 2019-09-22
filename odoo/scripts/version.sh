#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

current_dir=$PWD

if [[ $# -gt 1 ]]; then
    error "Illegal number of parameters"
    exit 1
fi


cd $ODOO_PATH/odoo
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
cd ../enterprise

if [[ `check_changes` == false ]]; then
    error "Odoo Enterprise : There are uncommited changes... Please reset your branch or stash the changes."
    exit 1
fi
git checkout -q $1
git pull -q
git clean -dfxq
branch=$(git symbolic-ref --short HEAD)
info "Odoo Enterprise version is now $branch"
cd ../design-themes

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