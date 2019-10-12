#!/bin/bash -
#
# Cybersecurity Ops with bash
# checkpass.sh
#
# Description: 
# Check a password against the
# Have I Been Pwned? database
#
# Usage: ./checkpass.sh [<password>]
#   <password> Password to check
#   default: read from stdin
#

if (( "$#" == 0 ))                              #<1>
then
    printf 'Enter your password: '
    read -s passin                              #<2>
	echo
else
    passin="$1"    
fi

passin=$(echo -n "$passin" | sha1sum)	          #<3>
passin=${passin:0:40}

firstFive=${passin:0:5}                         #<4>
ending=${passin:5}

pwned=$(curl -s "https://api.pwnedpasswords.com/range/$firstFive" | \
        tr -d '\r' | grep -i "$ending" )        #<5>
passwordFound=${pwned##*:}                      #<6>


if [ "$passwordFound" == "" ]
then
    exit 1
else
    printf 'Password is Pwned %d Times!\n' "$passwordFound"
    exit 0
fi

