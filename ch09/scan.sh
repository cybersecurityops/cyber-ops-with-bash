#!/bin/bash -
#
# Cybersecurity Ops with bash
# scan.sh
#
# Description: 
# Perform a port scan of a specified host
#
# Usage: ./scan.sh <output file>
#   <output file> File to save results in
#

function scan ()
{
  host=$1
  printf '%s' "$host"                                       # <1>
  for ((port=1;port<1024;port++))
  do
    # order of redirects is important for 2 reasons
    echo >/dev/null 2>&1  < /dev/tcp/${host}/${port}        # <2>
    if (($? == 0)) ; then printf ' %d' "${port}" ; fi       # <3>
  done
  echo # or printf '\n'
}

#
# main loop
#    read in each host name (from stdin)
#     and scan for open ports
#    save the results in a file
#    whose name is supplied as an argument
#     or default to one based on today's date
#

printf -v TODAY 'scan_%(%F)T' -1   # e.g., scan_2017-11-27  # <4>
OUTFILE=${1:-$TODAY}                                        # <5>

while read HOSTNAME
do
    scan $HOSTNAME
done > $OUTFILE                                             # <6>
