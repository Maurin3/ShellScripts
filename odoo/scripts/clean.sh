#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"

if [[ ! $1 || $2 ]]; then
    error "Illegal number of parameters"
    exit 1
fi

if [[ `db_exists $1` == false ]]; then
    error "The database does not exist..."
    exit 1
fi

sql="select id from res_users where active=true order by id limit 1"
id=$(psql -X -A -t -q -c "$sql" -d $1)

sql="select partner_id from res_users where id=$id"
partner_id=$(psql -X -A -t -q -c "$sql" -d $1)

info "Deactivating crons."
sql="update ir_cron set active='False';"
psql -c "$sql" -d $1 &> /dev/null
exit_on_error "Error while running SQL command to deativate crons"

info "Changing administrator credentials to admin:admin for user id $id in database $1."
sql="update res_users set login='admin',password='admin' where id=$id;"
psql -c "$sql" -d $1 &> /dev/null
exit_on_error "Error while running SQL command to reset admin credentials"

info "Removing queued mail jobs in database $1."
sql="delete from fetchmail_server;"
psql -c "$sql" -d $1 &> /dev/null
exit_on_error "Error while running SQL command to deativate the fetch of mails"
sql="delete from ir_mail_server;"
psql -c "$sql" -d $1 &> /dev/null
exit_on_error "Error while running SQL command to deativate the sending of mails"

info "Changing language for the administrator to English in database $1."
sql="update res_partner set lang = null where id=$partner_id;"
psql -c "$sql" -d $1 &> /dev/null
exit_on_error "Error while running SQL command to reset admin language"

now=`date -d "next year" +"%Y-%m-%d %T"`
sql="update ir_config_parameter set value = '$now' where key = 'database.expiration_date';"
psql -c "$sql" -d $1 &> /dev/null
exit_on_error "Error while running SQL command to update expiration date of the database"

complete
