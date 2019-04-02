#!/bin/bash -
#
# Cybersecurity Ops with bash
# getlocal.sh
#
# Description: 
# Gathers general system information and dumps it to a file
#
# Usage:
# bash getlocal.sh < cmds.txt
#   cmds.txt is a file with list of commands to run
#

# SepCmds - separate the commands from the line of input
function SepCmds()
{
      LCMD=${ALINE%%|*}                   # <11>
      REST=${ALINE#*|}                    # <12>
      WCMD=${REST%%|*}                    # <13>
      REST=${REST#*|}
      TAG=${REST%%|*}                     # <14>
      
      if [[ $OSTYPE == "MSWin" ]]
      then
         CMD="$WCMD"
      else
         CMD="$LCMD"
      fi
}

function DumpInfo ()
{                                                              # <5>
    printf '<systeminfo host="%s" type="%s"' "$HOSTNAME" "$OSTYPE"
    printf ' date="%s" time="%s">\n' "$(date '+%F')" "$(date '+%T')"
    readarray CMDS                           # <6>
    for ALINE in "${CMDS[@]}"                # <7>
    do
       # ignore comments
       if [[ ${ALINE:0:1} == '#' ]] ; then continue ; fi     # <8>

      SepCmds

      if [[ ${CMD:0:3} == N/A ]]             # <9>
      then
          continue
      else
          printf "<%s>\n" $TAG               # <10>
          $CMD
          printf "</%s>\n" $TAG
      fi
    done
    printf "</systeminfo>\n"
} 

OSTYPE=$(./osdetect.sh)                     # <1>
HOSTNM=$(hostname)                          # <2>
TMPFILE="${HOSTNM}.info"                    # <3>

# gather the info into the tmp file; errors, too
DumpInfo  > $TMPFILE  2>&1                  # <4>

