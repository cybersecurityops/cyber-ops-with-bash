#!/bin/bash -
#
# Cybersecurity Ops with bash
# histogram_plain.sh
#
# Description: 
# Generate a horizontal bar chart of specified data without
# using associative arrays, good for older versions of bash
#
# Usage: ./histogram_plain.sh
#   input format: label value
#

declare -a RA_key RA_val                                 # <1>
declare -i max ndx
max=0
maxbar=50    # how large the largest bar should be

ndx=0
while read labl val
do
    RA_key[$ndx]=$labl                                   # <2>
    RA_value[$ndx]=$val
    # keep the largest value; for scaling
    (( val > max )) && max=$val 
    let ndx++
done

# scale and print it
for ((j=0; j<ndx; j++))                                  # <3>
do
    printf "%-20.20s  " ${RA_key[$j]}
    pr_bar ${RA_value[$j]} $max
done
