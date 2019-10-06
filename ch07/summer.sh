#!/bin/bash -
#
# Cybersecurity Ops with bash
# summer.sh
#
# Description: 
# Sum the total of field 2 values for each unique field 1
#
# Usage: ./summer.sh
#   input format: <name> <number>
#

declare -A cnt        # assoc. array
while read id count
do
  let cnt[$id]+=$count
done
for id in "${!cnt[@]}"
do
    printf "%-15s %8d\n"  "${id}"  "${cnt[${id}]}" #<1>
done
