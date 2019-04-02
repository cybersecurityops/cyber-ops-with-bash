#!/bin/bash -
#
# Cybersecurity Ops with bash
# tailcount.sh
#
# Description: 
# Count lines every n seconds
#
# Usage: ./tailcount.sh [filename]
#   filename: passed to looper.sh
#

# cleanup - the other processes on exit
function cleanup ()
{
  [[ -n $LOPID ]] && kill $LOPID		# <1>
}

trap cleanup EXIT 				# <2>

bash looper.sh $1 &				# <3>
LOPID=$!					# <4>
# give it a chance to start up
sleep 3

while true
do
    kill -SIGUSR1 $LOPID
    sleep 5
done >&2					# <5>
