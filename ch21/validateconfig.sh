#!/bin/bash -
#
# Cybersecurity Ops with bash
# validateconfig.sh
#
# Description: 
# Validate a specified configuration exists
#
# Usage:
# validateconfig.sh < configfile
#
# configuration specification looks like:
# [[!]file|hash|reg|[!]user|[!]group] [args]
# examples:
# file /usr/local/bin/sfx 		- file exists
# hash 12384970347 /usr/local/bin/sfx   - file has this hash
# !user bono				- no user "bono" allowed
# group students			- must have a students group
#
# errexit - show correct usage and exit
function errexit ()
{
    echo "invalid syntax at line $ln"
    echo "usage: [!]file|hash|reg|[!]user|[!]group [args]"    # <1>
    exit 2

} # errexit

# vfile - vaildate the [non]existance of filename
#	args: 1: the "not" flag - value:1/0 
#             2: filename
#
function vfile ()
{
    local isThere=0
    [[ -e $2 ]] && isThere=1                    # <2>
    (( $1 )) && let isThere=1-$isThere          # <3>

    return $isThere

} # vfile

# verify the user id
function vuser ()
{
    local isUser
    $UCMD $2 &>/dev/null
    isUser=$?
    if (( $1 ))                                 # <4>
    then
        let isUser=1-$isUser
    fi

    return $isUser

} # vuser

# verify the group id
function vgroup ()
{
    local isGroup
    id $2 &>/dev/null
    isGroup=$?
    if (( $1 ))
    then
        let isGroup=1-$isGroup
    fi

    return $isGroup

} # vgroup

# verify the hash on the file
function vhash ()
{
    local res=0
    local X=$(sha1sum $2)                       # <5>
    if [[ ${X%% *} == $1 ]]                     # <6>
    then
        res=1
    fi

    return $res

} # vhash

# a windows system registry check
function vreg ()
{
    local res=0
    local keypath=$1
    local value=$2
    local expected=$3
    local REGVAL=$(query $keypath //v $value)

    if [[ $REGVAL == $expected ]]
    then
        res=1
    fi
    return $res

} # vreg

#
# main
#

# do this once, for use in verifying user ids
UCMD="net user"
type -t net &>/dev/null  || UCMD="id"           # <7>

ln=0
while read cmd args
do
    let ln++

    donot=0
    if [[ ${cmd:0:1} == '!' ]]                  # <8>
    then
        donot=1
	basecmd=${cmd#\!}                       # <9>
    fi

    case "$basecmd" in
    file)
        OK=1
        vfile $donot "$args"
        res=$?
        ;;
    hash)
        OK=1
	# split args into 1st word , remainder
        vhash "${args%% *}" "${args#* }"        # <10>
        res=$?
        ;;
    reg)
        # Windows Only!
        OK=1
        vreg $args
        res=$?
        ;;
    user)
        OK=0
        vuser $args
        res=$?
        ;;
    group)
        OK=0
        vgroup $args
        res=$?
        ;;
    *)  errexit					# <11>
        ;;
    esac
    
    if (( res != OK )) 
    then
        echo "FAIL: [$ln] $cmd $args"
    fi
done

