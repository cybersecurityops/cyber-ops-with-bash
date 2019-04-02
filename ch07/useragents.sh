#!/bin/bash -
#
# Cybersecurity Ops with bash
# useragents.sh
#
# Description: 
# Read through a log looking for unknown user agents
#
# Usage: ./useragents.sh  <  <inputfile>
#   <inputfile> Apache access log
#


# mismatch - search through the array of known names
#  returns 1 (false) if it finds a match
#  returns 0 (true) if there is no match
function mismatch ()                                    # <1>
{
    local -i i                                          # <2>
    for ((i=0; i<$KNSIZE; i++))
    do
        [[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1      # <3>
    done
    return 0
}

# read up the known ones
readarray -t KNOWN < "useragents.txt"                      # <4>
KNSIZE=${#KNOWN[@]}                                     # <5>

# preprocess logfile (stdin) to pick out ipaddr and user agent 
awk -F'"' '{print $1, $6}' | \
while read ipaddr dash1 dash2 dtstamp delta useragent   # <6>
do
    if mismatch "$useragent"
    then
        echo "anomaly: $ipaddr $useragent"
    fi
done
