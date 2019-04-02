#!/bin/bash

# baseline.sh

# create a baseline or secondary summary
if (( $# == 1 ))
then
    find / -type f | sha1sum > $1
    # all done for baseline
    exit
elif (( $# == 2 ))
then
    if [[ ! -r $1 ]]
    then
        echo "usage: baseline.sh file1 [file2]"
	exit 2
    fi
fi

# create a current summary
find / -type f | sha1sum > $2
# compare the two summaries
bash cmpbase.sh $1 $2 | sort | 

# sample output from cmpbase.sh | sort
# Changed: ./caveat.sample.ch
# NewFile: ./analyze/Project1/fd2.bck
# Removed: ./farm.sh
# Removed: ./x.x
# XFound: ./analyze/Project1/farm2.sh
# XFound: ./analyze/Project1/farm2.sh ./farm.sh

# convert these to an XML formatted output

awk -v SYSNM="$HOSTNAME" '

 BEGIN {
    print "<system name=\""SYSNM"\">"
    firstC=1 ; firstN=1 ; firstR=1 ; firstF=1
 }
 /^Changed:/ {
 	if (firstC) {
	    firstC=0
	    print "<changedfiles>"
	}
	print "  ", substr($0,9)
 }
 /^NewFile:/ {
 	if (firstN) {
	    firstN=0
	    if (firstC == 0) { print "</changedfiles>" }
	    printf "\n<newfiles>\n"
	}
	print "  ", substr($0,9)
 }
 /^Removed:/ {
 	if (firstR) {
	    firstR=0
	    if (firstN == 0) { print "</newfiles>" }
	    else if (firstC == 0) { print "</changedfiles>" }
	    printf "\n<removedfiles>\n"
	}
	print "  ", substr($0,9)
 }
 /^XFound:/ {  # two records per file
 	if (firstF) {
	    firstF=0
	    if (firstR == 0) { print "</removedfiles>" }
	    else if (firstN == 0) { print "</newfiles>" }
	    else if (firstC == 0) { print "</changedfiles>" }
	    print "\n<foundfiles>" 
	}
	FN=substr($0,9)
	FLEN=length($0)
	print "  <originalloc>"FN"</originalloc>"
	getline
	print "  <newloc>"substr($0, FLEN+2)"</newloc>"  # +2 0-based, space
 }

 END {
	if (firstF == 0) { print "</foundfiles>" }
	else if (firstR == 0) { print "</removedfiles>" }
	else if (firstN == 0) { print "</newfiles>" }
	else if (firstC == 0) { print "</changedfiles>" }
	print "</system>"
 }'
