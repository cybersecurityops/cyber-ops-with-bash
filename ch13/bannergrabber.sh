#!/bin/bash -
#
# Cybersecurity Ops with bash
# bannergrabber.sh
#
# Description:
# Automatically pull the banners from HTTP, SMTP,
# and FTP servers
#
# Usage: ./bannergrabber.sh  hostname [scratchfile]
#   scratchfile is used during processing but removed;
#   default is: "scratch.file" or tempfile-generated name
#

#
function isportopen ()
{
    (( $# < 2 )) && return 1                           # <1>
    local host port
    host=$1
    port=$2
    echo >/dev/null 2>&1  < /dev/tcp/${host}/${port}   # <2>
    return $?
}

function cleanup ()
{
    rm -f "$SCRATCH"
}

ATHOST="$1"
SCRATCH="$2"
if [[ -z $2 ]]
then
    if [[ -n $(type -p tempfile) ]]
    then
	SCRATCH=$(tempfile)
    else
    	SCRATCH='scratch.file'
    fi
fi

trap cleanup EXIT                                      # <3>
touch "$SCRATCH"                                       # <4>

if isportopen $ATHOST 21	# FTP                  <5>
then
    # i.e., ftp -n $ATHOST 
    exec 3<>/dev/tcp/${ATHOST}/21                      # <6>
    echo -e 'quit\r\n' >&3                             # <7>
    cat <&3  >> "$SCRATCH"                             # <8>
fi

if isportopen $ATHOST 25	# SMTP
then
    # i.e., telnet $ATHOST 25 
    exec 3<>/dev/tcp/${ATHOST}/25
    echo -e 'quit\r\n' >&3
    cat <&3  >> "$SCRATCH"
fi

if isportopen $ATHOST 80	# HTTP
then
    curl -LIs "https://${ATHOST}"  >> "$SCRATCH"      # <9>
fi

cat "$SCRATCH"                                        # <10>

