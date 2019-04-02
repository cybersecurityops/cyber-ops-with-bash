#!/bin/bash -
#
# Cybersecurity Ops with bash
# streamcipher.sh
#
# Description: 
# A lightweight implementation of a stream cipher
# Pedagogical - not recommended for serious use
#
# Usage:
# streamcipher.sh [-d] <key>  < inputfile
#   -d Decrypt mode
#   <key> Numeric key
#
#

source ./askey.sh                                          # <1>

#
# Ncrypt - Encrypt - reads in characters
#           outputs 2digit hex #s
#
function Ncrypt ()                                         # <2>
{
    TXT="$1"
    for((i=0; i< ${#TXT}; i++))                            # <3>
    do
	CHAR="${TXT:i:1}"                                  # <4>
	RAW=$(asnum "$CHAR") # " " needed for space (32)   # <5>
	NUM=${RANDOM}
	COD=$(( RAW ^ ( NUM & 0x7F )))                     # <6>
	printf "%02X" "$COD"                               # <7>
    done
    echo						   # <8>
}

#
# Dcrypt - DECRYPT - reads in a 2digit hex #s
#           outputs characters
#
function Dcrypt ()                                  # <9>
{
    TXT="$1"
    for((i=0; i< ${#TXT}; i=i+2))                   # <10>
    do
	CHAR="0x${TXT:i:2}"                         # <11>
	RAW=$(( $CHAR ))                            # <12>
	NUM=${RANDOM}
	COD=$(( RAW ^ ( NUM & 0x7F )))              # <13>
	aschar "$COD"                               # <14>
    done
    echo
}

if [[ -n $1  &&  $1 == "-d" ]]                      # <15>
then
    DECRYPT="YES" 
    shift                                           # <16>
fi

KEY=${1:-1776}                                      # <17>
RANDOM="${KEY}"                                     # <18>
while read -r                                       # <19>
do
    if [[ -z $DECRYPT ]]	                    # <20>
    then 
	Ncrypt "$REPLY"
    else
	Dcrypt "$REPLY"
    fi

done 
