#!/bin/bash -
#
# Cybersecurity Ops with bash
# autoscan.sh
#
# Description: 
# Automatically performs a port scan (using scan.sh), 
# compares output to previous results, and emails user
# Assumes that scan.sh is in the current directory.
#
# Usage: ./autoscan.sh
#

./scan.sh < hostlist                                      # <1>

FILELIST=$(ls scan_* | tail -2)                           # <2>
FILES=( $FILELIST )

TMPFILE=$(tempfile)                                       # <3>

./fd2.sh ${FILES[0]} ${FILES[1]}  > $TMPFILE

if [[ -s $TMPFILE ]]   # non-empty                        # <4>
then
    echo "mailing today's port differences to $USER"
    mail -s "today's port differences" $USER < $TMPFILE   # <5>
fi
# clean up
rm -f $TMPFILE                                            # <6>
