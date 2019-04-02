#!/bin/bash -
#
# Cybersecurity Ops with bash
# wintail.sh
#
# Description: 
# Perform a tail-like function on a Windows log
#
# Usage: ./wintail.sh 
#

WINLOG="Application"  #<1>

LASTLOG=$(wevtutil qe "$WINLOG" //c:1 //rd:true //f:text)  #<2>

while true
do
	CURRENTLOG=$(wevtutil qe "$WINLOG" //c:1 //rd:true //f:text)  #<3>
	if [[ "$CURRENTLOG" != "$LASTLOG" ]]
	then		
		echo "$CURRENTLOG"
		echo "----------------------------------"
		LASTLOG="$CURRENTLOG"
	fi
done
