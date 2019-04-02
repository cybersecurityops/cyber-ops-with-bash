#!/bin/bash -
#
# Cybersecurity Ops with bash
# fuzzer.sh
#
# Description: 
# Fuzz a specified argument of a program
#
# Usage:
# bash fuzzer.sh <executable> <arg1> [?] <arg3> ... 
#   <executable> The target executable program/script
#   <argn> The static arguments for the executable
#   '?' The argument to be fuzzed
#   example:  fuzzer.sh ./myprog -t '?' fn1 fn2
#

#
function usagexit ()                            # <1>
{
    echo "usage: $0 executable args"
    echo "example: $0 myapp -lpt arg \?"
    exit 1
} >&2						# <2>

if (($# < 2))					# <3>
then
    usagexit
fi

# the app we will fuzz is the first arg
THEAPP="$1"
shift						# <4>
# is it really there?
type -t "$THEAPP" >/dev/null  || usagexit    # <5>

# which arg to vary?
# find the ? and note its position
declare -i i
for ((i=0; $# ; i++))				# <6>
do
    ALIST+=( "$1" )				# <7>
    if [[ $1 == '?' ]]
    then
	NDX=$i					# <8>
    fi
    shift
done

# printf "Executable: %s  Arg: %d %s\n" "$THEAPP" $NDX "${ALIST[$NDX]}"

# now fuzz away:
MAX=10000
FUZONE="a"
FUZARG=""
for ((i=1; i <= MAX; i++))			# <9>
do
    FUZARG="${FUZARG}${FUZONE}"  # aka +=
    ALIST[$NDX]="$FUZARG"
    # order of >s is important
    $THEAPP "${ALIST[@]}"  2>&1 >/dev/null      # <10>
    if (( $? )) ; then echo "Caused by: $FUZARG" >&2 ; fi  # <11>
done

