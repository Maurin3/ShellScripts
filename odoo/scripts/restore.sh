#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

if [[ `db_exists $1` != true ]]; then
    error "The database does not exist..."
    exit 1
fi

if [[ ! -f "$2" ]]; then
    error "Could not locate dump file at $2"
    exit 1
fi

file=`basename $2`
[[ "$file" =~ \.(zip|dump|sql|gz)$ ]] && type=${BASH_REMATCH[1]}

info "Restoring dump file $file to local database $1"
info "This may take a while..."

if [[ "$type" == "dump" ]]; then
    info "Restoring SQL dump to database $1..."
    pg_restore -d $1 $2 &> /dev/null
elif [[ "$type" == "sql" ]]; then
    info "Restoring SQL dump to database $1..."
    psql $1 < $2 &> /dev/null
elif [[ "$type" == "gz" ]]; then
    info "Restoring SQL dump to database $1..."
    gunzip -c $2 | psql $1 &>/dev/null
elif [[ "$type" == "zip" ]]; then
    t_dir=/tmp/odoo/$1
    pwd=`pwd`
    if [[ -f $t_dir/$file ]]; then
        info "Found existing dump in $t_dir/$file, deleting it..."
        rm -Rf $t_dir
    fi

    info "Switching to temporary directory $t_dir..."
    mkdir -p $t_dir && cp $2 $t_dir && cd $t_dir
    exit_on_error "Error switching to temporary directory $t_dir"

    info "Unzipping file $t_dir/$file..."
    unzip $file &> /dev/null

    if [[ ! -f $t_dir/dump.sql ]]; then
        error "Error unzipping file $file"
        exit 1
    fi

    fs_dir=$HOME/.local/share/Odoo/filestore
    if [[ -d ./filestore ]]; then
        info "Filestore detected, installing to $fs_dir/$1/..."
        cp -r ./filestore/* $fs_dir/$1
        exit_on_error "Error while copying filestore directory to $fs_dir/$1/"
    fi

    info "Restoring SQL dump to database $1..."
    psql $1 < dump.sql &> /dev/null
    exit_on_error "Error while restoring SQL dump to database $1"

    info "Removing temporary files..."
    cd $pwd
    rm -Rf $t_dir &> /dev/null
    exit_on_error "Error while removing temporary files in $t_dir"
else
    error "Unsupported file format for $file"
    exit 1
fi

complete