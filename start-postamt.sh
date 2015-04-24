#!/bin/bash

# initialize database
postamt init

if [ ! -f $POSTAMT_VMAIL ]; then
    mkdir -p $POSTAMT_VMAIL;
    chown postamt.postamt $POSTAMT_VMAIL;
fi

# to have a mounted data volume functional
# we have to setup resp. ensure some things to be there

function create_self_signed_cert {
    BASE=$1
    CN=$2

    openssl req -new -x509 -nodes\
        -days 3650\
        -subj "/C=$POSTAMT_SSL_C/ST=$POSTAMT_SSL_ST/L=$POSTAMT_SSL_L/CN=$CN"\
        -newkey rsa:2048\
        -keyout $BASE.key -out $BASE.crt

    openssl x509 -subject -fingerprint -noout -in $BASE.crt || exit 2

    chgrp postamt $KEY
    chmod 0660 $KEY
}

mkdir -p $POSTAMT_SSL

# setup hostname
echo $HOSTNAME > /etc/hostname

# dovecot ssl
if [ ! -f "$POSTAMT_DOVECOT_SSL.key" ] || [ ! -z "$POSTAMT_SSL_MAKE" ]; then
    # create new
    create_self_signed_cert $POSTAMT_DOVECOT_SSL $POSTAMT_DOVECOT_SSL_CN
fi

# postfix ssl
if [ ! -f $POSTAMT_POSTFIX_SSL.key ] || [ ! -z "$POSTAMT_SSL_MAKE" ]; then
    # create new
    create_self_signed_cert $POSTAMT_POSTFIX_SSL $POSTAMT_POSTFIX_SSL_CN
fi


# postfix helo_checks
touch $POSTAMT_DATA/helo_checks


# TODO may be turn this off
# aliases
touch /var/lib/mailman/aliases
/usr/lib/mailman/bin/genaliases
newaliases



# start
supervisord -n
