#!/bin/bash -
#
# Cybersecurity Ops with bash
# checkemail.sh
#
# Description: 
# check an email address against the
# Have I Been Pwned? database
#
# Usage: ./checkemail.sh [<email>]
#   <email> Email address to check; default: reads from stdin
#

if (( "$#" == 0 ))	#<1>
then
	printf 'Enter email address: '
	read emailin
else
	emailin="$1"
fi

pwned=$(curl -s "https://haveibeenpwned.com/api/v2/breachedaccount/$emailin")	#<2>

if [ "$pwned" == "" ]
then
	exit 1
else
	echo 'Account pwned in the following breaches:'
	echo "$pwned" | grep -Po '"Name":".*?"' | cut -d':' -f2 | tr -d '\"'	#<3>
	exit 0
fi

