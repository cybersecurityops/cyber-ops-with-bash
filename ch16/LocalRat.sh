#!/bin/bash -
#
# Cybersecurity Ops with bash
# LocalRat.sh
#
# Description: 
# Remote access tool to be on a local system,
# it listens for a connection from the remote system
# and helps with any file transfer requested
#
# Usage:  LocalRat.sh  port1 [port2 [port3]]
# 
#

# define our background file transfer daemon
function bgfilexfer ()
{
    while true
    do
        FN=$(nc -nlvvp $HOMEPORT2 2>>/tmp/x2.err)       # <3>
        if [[ $FN == 'exit' ]] ; then exit ; fi
        nc -nlp $HOMEPORT3 < $FN                        # <4>
    done
}


# -------------------- main ---------------------
HOMEPORT=$1
HOMEPORT2=${2:-$((HOMEPORT+1))}
HOMEPORT3=${3:-$((HOMEPORT2+1))}

# initiate the background file transfer daemon
bgfilexfer &                                            # <1>

# listen for an incoming connection 
nc -nlvp $HOMEPORT                                      # <2>

