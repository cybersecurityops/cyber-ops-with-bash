#!/bin/bash -
#
# Cybersecurity Ops with bash
# emailbatch.sh
#
# Description: 
# Read in a file of email addresses and run them
# against Have I Been Pwned
#
# Usage: ./emailbatch.sh [<filename>]
#   <filename> File with one email address on each line
#   default: reads from stdin
#

cat "$1" | tr -d '\r' | while read fileLine		#<1>
do	
	./checkemail.sh "$fileLine" > /dev/null	#<2>
	
	if (( "$?" == 0 ))	#<3>
	then
		echo "$fileLine is Pwned!"
	fi
	
	sleep 0.25		#<4>
done
