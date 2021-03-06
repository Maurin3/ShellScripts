#!/usr/bin/env bash

DIR="$ODOO_SCRIPTS"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
sdir="$DIR/scripts"
source "$sdir/utils.sh"

# Variables
ODOO_PATH="$ODOO_PATH"
if [[ ! -d "$ODOO_PATH" ]]; then ODOO_PATH="$HOME/Documents/Odoo"; fi

args=${@:2}

export is_from_mig=0

# Main
case $1 in
    -h|--help)
        $sdir/help.sh $0
        ;;
    create|cr)
        $sdir/create.sh $args
        ;;
    remove|rm)
        $sdir/remove.sh $args
        ;;
    list|ls)
        $sdir/list.sh
        ;;
    upgrade|upg)
        $sdir/upgrade.sh $args
        ;;
    migration|mig)
        $sdir/migration.sh $args
        ;;
    restore|rs)
        $sdir/restore.sh $args
        ;;
    clean|cl)
        $sdir/clean.sh $args
        ;;
    download|dw)
        $sdir/download.sh $args
        ;;
    run|rn)
        $sdir/run.sh $args
        ;;
    version|vs)
        $sdir/version.sh $args
        ;;
    reset|res)
        $sdir/reset.sh
        ;;
    deploy|dp)
        $sdir/deploy.sh $args
        ;;
    shell|sh)
        $sdir/shell.sh $args
        ;;
    template|tpl)
        $sdir/template.sh $args
        ;;
    kill|stop)
        $sdir/kill.sh $args
        ;;
    *)
        error "Unrecognized command: $0 $1"
        ;;
esac

exit $?
