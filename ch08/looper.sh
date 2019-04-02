#!/bin/bash -
#
# Cybersecurity Ops with bash
# looper.sh
#
# Description: 
# Count the lines in a file being tailed -f
# Report the count interval on every SIGUSR1
#
# Usage: ./looper.sh [filename]
#   filename of file to be tailed, default: log.file
# 

function interval ()					# <1>
{
    echo $(date '+%y%m%d %H%M%S') $cnt			# <2>
    cnt=0
}

declare -i cnt=0
trap interval SIGUSR1					# <3>

shopt -s lastpipe					# <4>

tail -f --pid=$$ ${1:-log.file} | while read aline	# <5>
do
    let cnt++
done
