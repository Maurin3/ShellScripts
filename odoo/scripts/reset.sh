#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

current_dir=$PWD
if [[ $# -gt 0 ]]; then
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

declare -A odoo_table
odoo_table=(["Themes"]=$design_themes ["Enterprise"]=$enterprise ["Community"]=$odoo_dir)
for edition in "${!odoo_table[@]}"
do
    if [[ `check_changes ${odoo_table[$edition]}` == true ]]; then
        info "No changes in Odoo $edition repository"
    else
        info "Odoo $edition repository has been reset"
        git -C ${odoo_table[$edition]} reset -q --hard
        git -C ${odoo_table[$edition]} clean -dfxq
    fi
done

complete