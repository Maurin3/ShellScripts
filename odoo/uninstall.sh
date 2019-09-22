#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/scripts/utils.sh"

info "Uninstalling the Odoo scripts..."
pwd=`pwd`
loc=`ask "Where are installed the scripts? (default: $pwd)"`

if [[ -z "$loc" ]]; then
    loc=$pwd
fi

mkdir -p "$loc" &> /dev/null
exit_on_error "$loc is not a directory"

if [[ "$loc" != "$pwd" ]]; then
    info "Removing the scripts to $loc"
    rm -rf $pwd/scripts 
    rm -rf $loc/scripts
    rm $pwd/odoo.sh
    rm $loc/odoo.sh
    exit_on_error "Could not remove the scripts to $loc"
    info "Done!"
fi

info "Removing the global availability of scripts..."
cd /usr/bin
if [[ -e odoo ]]; then
    warning "We'll need to run the next command as SUDO to remove Odoo Scripts to your applications"
    sudo unlink odoo &> /dev/null
    exit_on_error "Error removing shortcut /usr/bin/$filename to $loc/odoo.sh"
else
    warning "/usr/bin/odoo does not exist, cannot remove symbolic link to $loc/odoo.sh"
fi

if [ -n `$SHELL -c 'echo $ZSH_VERSION'` ]; then
    if [ `grep -wc "ODOO_SCRIPTS" $HOME/.zshrc` = 1 ]; then
        sed -i.bak -e "/ODOO_PATH=.*/d" $HOME/.zshrc
        sed -i.bak -e "/ODOO_SCRIPTS=.*/d" $HOME/.zshrc
        source $HOME/.zshrc &>/dev/null
    else
        error "ODOO_PATH and ODOO_SCRIPTS are not present in your ~/.zshrc file"
        exit 1
    fi
elif [ -n `$SHELL -c 'echo $BASH_VERSION'` ]; then
    if [ `grep -wc "ODOO_SCRIPTS" $HOME/.bashrc` = 1 ]; then
        sed -ie "#(ODOO_PATH=).*#d" $HOME/.bashrc
        sed -ie "#(ODOO_SCRIPTS=).*#d" $HOME/.bashrc
        source $HOME/.bashrc &>/dev/null
    else
        error "ODOO_PATH and ODOO_SCRIPTS are not present in your ~/.bashrc file"
        exit 1
    fi
fi

complete