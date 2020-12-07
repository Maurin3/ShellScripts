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

if [[ $# = 0 ]]; then
    branch=$(git -C $odoo_dir symbolic-ref --short HEAD)
    info "Odoo version: $branch"
    exit 0
fi

info "This operation can take some time. (Odoo Community repository has a great number of commits)"

declare -A odoo_table
odoo_table=(["Themes"]=$design_themes ["Enterprise"]=$enterprise ["Community"]=$odoo_dir)

for edition in "${!odoo_table[@]}"
do
    if [[ `check_changes ${odoo_table[$edition]}` == false ]]; then
        error "Odoo $edition : There are uncommited changes... Please reset your branch or stash the changes."
        exit 1
    fi
done

for edition in "${!odoo_table[@]}"
do
    git -C ${odoo_table[$edition]} checkout -q $1
    git -C ${odoo_table[$edition]} pull --prune -q
    git -C ${odoo_table[$edition]} clean -dfxq
    branch=$(git -C ${odoo_table[$edition]} symbolic-ref --short HEAD)
    info "Odoo $edition version is now $branch"
done

complete