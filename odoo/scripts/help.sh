#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

info "Usage: odoo [command...]"
echo
echo "Commands [<mandatory> (<optional>)] :"
aligned "cl, clean <dbname>                                    Clean db, reset admin user (admin/admin), deactivate crons"
aligned "cr, create <dbname>                                   Create a new db with dbname as name "
aligned "dp, deploy <dbname> <module>                          Deploy the module in the database "
aligned "ls, list                                              List databases"
aligned "mig sym, migration symlink                            Create a symbolic link between the saas-migration and the base module "
aligned "mig pull, migration pull                              Retrieve the changes from the Upgrade repository "
aligned "mig sh, migration shell <dbname> (<dir>) (<options>)  Run a 2nd Odoo as shell with db (dbname) and dir as added addons (+options) "
aligned "mig rn, migration run <dbname> (<dir>) (<options>)    Run a 2nd Odoo with db (dbname) and dir as added addons (+options) "
aligned "mig rs, migration reset <dbname> (<dir>) (<options>)  Reset the current branch of 2nd Odoo repositories "
aligned "mig vs, migration version (<number>)                  Display the version or change to the version desired of 2nd Odoo repositories "
aligned "rm, remove <dbname>                                   Remove the database with name dbname and its possible filestore "
aligned "res, reset                                            Reset the current branch of Odoo repositories "
aligned "rs, restore <dbname> <dumpfile>                       Restore db with dumpfile "
aligned "rn, run <dbname> (<dir>) (<options>)                  Run Odoo with db (dbname) and dir as added addons (+options)"
aligned "sh, shell <dbname> (<dir>) (<options>)                Run Odoo as shell with db (dbname) and dir as added addons (+options)"
aligned "vs, version <number>                                  Display the version or change to the version desired "
aligned "tpl, template <dbname1> <dbname2>                     Copy a dbname2 from dbname1 "
echo ""

complete