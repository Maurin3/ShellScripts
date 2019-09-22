#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

info "Usage: $1 [option...] {clean|create|deploy|download|list|migration|remove|reset|restore|run|shell|version|template}"
echo
aligned "  cl, clean <dbname>                   Clean db, reset admin user (admin/admin), deactivate crons"
aligned "  cr, create <dbname>                  Create a new db with dbname as name "
aligned "  dp, deploy <module> <dbname>         Deploy the module in the database "
aligned "  ls, list                             List databases"
aligned "  mig, migration                       Create a symbolic link between the saas-migration and the base module "
aligned "  rm, remove <dbname>                  Remove the database with name dbname and its possible filestore "
aligned "  res, reset                           Reset the current branch of Odoo repositories "
aligned "  rs, restore <dbname> <dumpfile>      Restore db with dumpfile "
aligned "  rn, run <dbname> <dir> <options>     Run Odoo with db (dbname) and dir as added addons (+options)"
aligned "  sh, shell <dbname> <dir> <options>   Run Odoo as shell with db (dbname) and dir as added addons (+options)"
aligned "  vs, version <number>                 Display the version or change to the version desired "
aligned "  tpl, template <dbname1> <dbname2>    Copy a dbname2 from dbname1 "
echo ""

complete