#!/bin/bash -
#
# Cybersecurity Ops with bash
# winlogs.sh
#
# Description: 
# Gather copies of Windows log files
#
# Usage:
# winlogs.sh [-z] [dir]
#   -z   Tar and zip the output
#   dir  Optional scratch directory for holding the log files

TGZ=0
if (( $# > 0 ))						# <1>
then
    if [[ ${1:0:2} == '-z' ]]				# <2>
    then
	TGZ=1	# tgz flag to tar/zip the log files
	shift
    fi
fi
SYSNAM=$(hostname)
LOGDIR=${1:-/tmp/${SYSNAM}_logs}			# <3>

mkdir -p $LOGDIR					# <4>
cd ${LOGDIR} || exit -2

wevtutil el | while read ALOG				# <5>
do
    ALOG="${ALOG%$'\r'}"				# <6>
    echo "${ALOG}:"					# <7>
    SAFNAM="${ALOG// /_}"				# <8>
    SAFNAM="${SAFNAM//\//-}"
    wevtutil epl "$ALOG" "${SYSNAM}_${SAFNAM}.evtx"
done

if (( TGZ == 1 ))					# <9>
then
    tar -czvf ${SYSNAM}_logs.tgz *.evtx			# <10>
fi
