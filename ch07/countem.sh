#!/bin/bash -
#
# Cybersecurity Ops with bash
# countem.sh
#
# Description: 
# Count the number of instances of an item using bash
#
# Usage:
# countem.sh < inputfile
#

declare -A cnt        # assoc. array             # <1>
while read id xtra                               # <2>
do
    let cnt[$id]++                               # <3>
done
# now display what we counted
# for each key in the (key, value) assoc. array
for id in "${!cnt[@]}"                           # <4>
do    
	printf '%s %d\n'  "$id"  "${cnt[$id]}"       # <5>
done
