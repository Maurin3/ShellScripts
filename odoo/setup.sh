#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/scripts/utils.sh"

warning "Make sure you chenged your preferred shell before running this script."
aligned "You can change your preferred shell by doing 'chsh -s path/to/shell' in your terminal."
info "Bash is located in '/bin/bash' and is the default one."
info "Zsh is located in '/usr/bin/zsh' and isn't installed by default."
warning "You need to log out then back in to see the changes take effect."

if [[ `confirm "Do you want to continue?"` != true ]]; then
    exit 1
fi

info "Setting up the local path to Odoo..."
warning "The software you are about to install assumes that you have cloned the Odoo repositories locally on your system"
aligned "using GIT and that those directories are located next to each other in your filesystem."
aligned "For example, if your odoo-bin executable is located at '/home/user/git/odoo/', then Odoo enterprise should be"
aligned "located at '/home/user/git/enterprise/' and the answer to the next question should be '/home/user/git/'"

path=`ask "Where are your Odoo directories located?"`
correct_path="$path"
[[ ! "$path" =~ .*/$ ]] && path="$path/"
info   "Assuming the following locations:"
aligned "Odoo Community:     ${path}odoo"
aligned "Odoo Enterprise:    ${path}enterprise"
aligned "Design Themes:      ${path}design-themes"

if [[ `confirm "Is it correct?"` != true ]]; then
    error "Could not configure Odoo paths"
    exit 1
fi

if [[ ! -f $path/odoo/odoo-bin ]]; then
    error "Could not find the odoo-bin executable in $path/odoo/"
    exit 1
fi

info "Setting up the Odoo scripts..."
pwd=`pwd`
loc=`ask "Where do you want to install the scripts? (default: $pwd)"`

if [[ -z "$loc" ]]; then
    loc=$pwd
fi

mkdir -p "$loc" &> /dev/null
exit_on_error "$loc is not a directory"

if [[ "$loc" != "$pwd" ]]; then
    info "Copying the scripts to $loc"
    cp -r $pwd/scripts $loc/scripts &> /dev/null && \
    cp $pwd/odoo.sh $loc/odoo.sh &> /dev/null
    exit_on_error "Could not copy the scripts to $loc"
    info "Done!"
fi

info "Making the scripts globally available..."
cd /usr/bin
if [[ -e odoo ]]; then
    warning "/usr/bin/odoo already exists, cannot create symbolic link to $loc/odoo.sh"
else
    warning "We'll need to run the next command as SUDO to add Odoo Scripts to your applications"
    sudo ln -sf $loc/odoo.sh odoo &> /dev/null
    exit_on_error "Error creating shortcut /usr/bin/$filename to $loc/odoo.sh"
fi

# Done!
info "All good"

s="'$SHELL'"
# Remove the quotes
shell_type=${s##*/}

if [[ $shell_type  == 'zsh' ]]; then
    if [ `grep -wc "ODOO_SCRIPTS" $HOME/.zshrc` = 0 ]; then
        if [ ! -z `tail -c 1 $HOME/.zshrc` ]; then
            sed -i.bak -e '$a\' $HOME/.zshrc
        fi
        echo "export ODOO_PATH=$correct_path" >> $HOME/.zshrc
        echo "export ODOO_SCRIPTS=$loc" >> $HOME/.zshrc
        source $HOME/.zshrc &>/dev/null
    else
        error "ODOO_PATH and ODOO_SCRIPTS are already present in your ~/.zshrc file"
        exit 1
    fi
elif [[ $shell_type  == 'bash' ]]; then
    if [ `grep -wc "ODOO_SCRIPTS" $HOME/.bashrc` = 0 ]; then
        if [ ! -z `tail -c 1 $HOME/.bashrc` ]; then
            sed -i.bak -e '$a\' $HOME/.bashrc
        fi
        echo "export ODOO_PATH=$correct_path" >> $HOME/.bashrc
        echo "export ODOO_SCRIPTS=$loc" >> $HOME/.bashrc
        source $HOME/.bashrc &>/dev/null
    else
        error "ODOO_PATH and ODOO_SCRIPTS are already present in your ~/.bashrc file"
        exit 1
    fi
fi

echo # new line
warning "Make sure the variables ODOO_PATH and ODOO_SCRIPTS are your ~/.bashrc or ~/.zshrc file before using the scripts, or simply re-open your terminal,"
aligned "then run 'odoo version' to verify the scripts are working as expected"

complete