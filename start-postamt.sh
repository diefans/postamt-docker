#!/bin/bash

# first check for db
if [ ! -f "$DB" ]; then
    echo "creating db: $DB" >&2
    # create db
    cat create.sql | sqlite3 -echo $DB;
else
    echo "using db: $DB" >&2

fi

# start
supervisord -n
