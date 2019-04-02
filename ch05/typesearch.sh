#!/bin/bash -
#
# Cybersecurity Ops with bash
# typesearch.sh
#
# Description: 
# Search the file system for a given file type. It prints out the
# pathname when found.
#
# Usage:
# typesearch.sh [-c dir] [-i] [-R|r] <pattern> <path>
#   -c Copy files found to dir
#   -i Ignore case
#   -R|r Recursively search subdirectories
#   <pattern> File type pattern to search for
#   <path> Path to start search
#

DEEPORNOT="-maxdepth 1"		# just the current dir; default

# PARSE option arguments:
while getopts 'c:irR' opt; do                         # <1>
  case "${opt}" in                                    # <2>
    c) # copy found files to specified directory
	       COPY=YES
	       DESTDIR="$OPTARG"                             # <3>
	       ;;
    i) # ignore u/l case differences in search
	       CASEMATCH='-i'
	       ;;
    [Rr]) # recursive                                 # <4>
        unset DEEPORNOT;;                             # <5>
    *)  # unknown/unsupported option                  # <6>
        # error mesg will come from getopts, so just exit
        exit 2 ;;
  esac
done
shift $((OPTIND - 1))                                 # <7>


PATTERN=${1:-PDF document}                            # <8>
STARTDIR=${2:-.}	# by default start here

find $STARTDIR $DEEPORNOT -type f | while read FN     # <9>
do
    file $FN | egrep -q $CASEMATCH "$PATTERN"          # <10>
    if (( $? == 0 ))   # found one                    # <11>
    then
	        echo $FN
	        if [[ $COPY ]]                               # <12>
	        then
	            cp -p $FN $DESTDIR                       # <13>
	        fi
    fi
done

