#!/bin/bash
#
# checkemail.sh - check an email address against
#                 the Have I Been Pwned? database
#

if (( "$#" == 0 ))                     #<1>
then
    printf 'Enter email address: '
    read emailin
else
    emailin="$1"
fi

URL="https://haveibeenpwned.com/api/v2/breachedaccount/$emailin"
pwned=$(curl -s "$URL" |  grep -Po '"Name":".*?"' )   #<2>

if [ "$pwned" == "" ]
then
    exit 1
else
    echo 'Account pwned in the following breaches:'   # <3>
    pwned="${pwned//\"/}"         # remove all quotes
    pwned="${pwned//Name:/}"      # remove all 'Name:'
    echo "${pwned}"
    exit 0
fi
