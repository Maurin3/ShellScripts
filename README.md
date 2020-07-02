# ShellScripts

Some useful Shell Scripts :wink:

Odoo's scripts are greatly inspired by [AVS's scripts](https://github.com/brinkflew/odoo-scripts)...

## Odoo's scripts Installation

Clone this repository, go inside the cloned repository and run the setup script

```shell
git clone https://github.com/Maurin3/ShellScripts.git
cd ShellScripts
cd odoo
./setup.sh
```

## Update

Simply go in the repo, `git pull` in the repository to update to the latest version.

You may have to rerun the setup script if you didn't keep your local repository as install path, otherwise you are good to go!

## Odoo's scripts Uninstall

Go inside the repository and run the uninstall script

```shell
cd /path/to/ShellScripts repo
cd odoo
./uninstall.sh
```

## Odoo Commands

The following commands are prefixed with `odoo`. Only arguments in brackets `(<arg>)` are optional and can be omitted.

| Command                                                    | Aliases      | Description                                                                   |
|------------------------------------------------------------|--------------|-------------------------------------------------------------------------------|
| `--help`                                                   | `-h`         | Display help                                                                  |
| `clean <dbname>`                                           | `cl`         | Clean db, reset admin user (admin/admin), deactivate crons                    |
| `create <dbname>`                                          | `cr`         | Create a new db with dbname as name                                           |
| `deploy <dbname> <module>`                                 | `dp`         | Deploy a module to an existing local database                                 |
| `list`                                                     | `ls`         | List databases                                                                |
| `migration`                                                | `mig`        | Create a symbolic link between the saas-migration and the base module         |
| `migration shell <dbname> (<dir>) (<options>)`             | `mig sh`     | Run a 2nd Odoo as shell with db (dbname) and dir as added addons (+options)   |
| `migration run <dbname> (<dir>) (<options>)`               | `mig rn`     | Run a 2nd Odoo with db (dbname) and dir as added addons (+options)            |
| `migration reset <dbname> (<dir>) (<options>)`             | `mig rs`     | Reset the current branch of 2nd Odoo repositories                             |
| `migration version (<number>)`                             | `mig vs`     | Display the version or change to the version desired of 2nd Odoo repositories |
| `remove <dbname>`                                          | `rm`         | Remove the database with name dbname and its possible filestore               |
| `reset`                                                    | `res`        | Reset the current branch of Odoo repositories                                 |
| `restore <database> <dump file>`                           | `rs`         | Restore db with dumpfile                                                      |
| `run <dbname> (<dir>) (<options>)`                         | `rn`         | Run Odoo with db (dbname) and dir as added addons (+options)                  |
| `shell <dbname> (<dir>) (<options>)`                       | `sh`         | Run Odoo as shell with db (dbname) and dir as added addons (+options)         |
| `version (<number>)`                                       | `vs`         | Display the version or change to the version desired                          |
| `template <dbname1> <dbname2>`                             | `tpl`        | Copy a dbname2 from dbname1                                                   |
