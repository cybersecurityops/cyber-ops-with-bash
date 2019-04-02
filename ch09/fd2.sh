#!/bin/bash -
#
# Cybersecurity Ops with bash
# fd2.sh
#
# Description: 
# Compares two port scans to find changes
# MAJOR ASSUMPTION: both files have the same # of lines,
# each line with the same host address
# though with possibly different listed ports
#
# Usage: ./fd2.sh <file1> <file2>
#

# look for "$LOOKFOR" in the list of args to this function
# returns true (0) if it is not in the list
function NotInList ()                                            # <1>
{
    for port in "$@"
    do
        if [[ $port == $LOOKFOR ]]
        then
            return 1
        fi
    done
    return 0
}

while true
do
    read aline <&4 || break         # at EOF                  # <2>
    read bline <&5 || break         # at EOF, for symmetry    # <3>

    # if [[ $aline == $bline ]] ; then continue; fi
    [[ $aline == $bline ]] && continue;                       # <4>

    # there's a difference, so we
    # subdivide into host and ports
    HOSTA=${aline%% *}                                        # <5>
    PORTSA=( ${aline#* } )                                    # <6>

    HOSTB=${bline%% *}
    PORTSB=( ${bline#* } )

    echo $HOSTA                 # identify the host which changed

    for porta in ${PORTSA[@]}
    do         # <7>
          LOOKFOR=$porta NotInList ${PORTSB[@]} && echo "  closed: $porta"
    done

    for portb in ${PORTSB[@]}
    do
          LOOKFOR=$portb NotInList ${PORTSA[@]} && echo "     new: $portb"
    done

done 4< ${1:-day1.data} 5< ${2:-day2.data}                   # <8>
# day1.data and day2.data are default names to make it easier to test
