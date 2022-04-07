#!/bin/sh

echo "running postfix-init"

if ! [ -z "$POSTFIX_MYHOSTNAME" ]; then
        echo "setting myhostname"
        postconf -e "myhostname = $POSTFIX_MYHOSTNAME"
fi

MY_NETWORK=${MY_NETWORK:-"127.0.0.0/8, 172.0.0.0/8"}

# configure logging to stdout per
# <http://www.postfix.org/MAILLOG_README.html>.
postconf -e 'maillog_file = /dev/stdout'
postconf -e "mynetworks=${MY_NETWORK}"
postconf -e 'inet_interfaces = all'

# the postfix systemd unit runs aliasesdb as an ExecStartPre
# script, so we should probably run it here.
/usr/libexec/postfix/aliasesdb

exec "$@"
