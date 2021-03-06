#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/utils.sh"


sql="SELECT datname FROM pg_database WHERE datname NOT IN ('template0', 'template1', 'postgres') ORDER BY datname"
list=`psql -t -A -c "$sql" postgres`

printf "%-20s | %-12s | %-20s\n" 'Databases' 'Version' 'Filestore'
for i in {1..52}
do
    printf '='
done
printf '\n'

cur_dir=$(pwd)

for db in $list
do
    sql="SELECT latest_version FROM ir_module_module WHERE name='base'"
    version=`psql -t -A -c "$sql" $db 2> /dev/null`
    version=${version%.*.*}
    if [[ -z "$version" ]]; then
        version="No"
    fi
    if [[ -d ~/.local/share/Odoo/filestore/$db ]]; then
        cd ~/.local/share/Odoo/filestore/$db
        res=$(ls -A | wc -l)
        if [ $res -gt 100 ]; then
            filestore="✔"
            printf "%-20s | %-12s | %b %-20s %b \n" $db $version $LIGHT_GREEN $filestore $NC
        else
            filestore='✘'
            printf "%-20s | %-12s | %b %-20s %b \n" $db $version $RED $filestore $NC
        fi
    else
        filestore='✘'
        printf "%-20s | %-12s | %b %-20s %b \n" $db $version $RED $filestore $NC
    fi
done

cd $cur_dir

echo

complete