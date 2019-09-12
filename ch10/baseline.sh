#!/bin/bash

# baseline.sh - compare baselines
#              and report on differences
#

function usageErr ()
{
    echo 'usage: baseline.sh [-d path] file1 [file2]'
    echo 'creates or compares a baseline from path'
    echo 'default for path is /'
    exit 2
} >&2                                                          # <1>

function dosumming ()
{
    find "${DIR[@]}" -type f | xargs -d '\n' sha1sum           # <2>
}

# ===============================
# MAIN
# ===============================

declare -a DIR

# ---------- parse the arguments 

while getopts "d:" MYOPT                                   # <3>
do
    # no check for MYOPT since there is only one choice
    DIR+=( "$OPTARG" )                                     # <4>
done
shift $((OPTIND-1))                                        # <5>

# no arguments? too many?
(( $# == 0 || $# > 2 )) &&  usageErr 

(( ${#DIR[*]} == 0 )) && DIR=( "/" )                       # <6>


# create either a baseline (only 1 filename provided)
# or a secondary summary (when two filenames are provided)

BASE="$1"
B2ND="$2"

if (( $# == 1 ))    # only 1 arg.
then
    # creating "$BASE"
    dosumming > "$BASE" 
    # all done for baseline
    exit
fi

if [[ ! -r "$BASE" ]]
then
    usageErr
fi

# --------- on to the actual work:

# if 2nd file exists just compare the two
# else create/fill it
if [[ ! -e "$B2ND" ]]
then
    echo creating "$B2ND"
    dosumming > "$B2ND"
fi

# now we have: 2 files created by sha1sum
declare -A BYPATH BYHASH INUSE 	# assoc. arrays

# load up the first file as the baseline
while read HNUM FN
do
    BYPATH["$FN"]=$HNUM
    BYHASH[$HNUM]="$FN"
    INUSE["$FN"]="X"
done < "$BASE"

# ------ now begin the output
# see if each filename listed in the 2nd file is in
# the same place (path) as in the 1st (the baseline)

printf '<filesystem host="%s" dir="%s">\n' "$HOSTNAME"  "${DIR[*]}"

while read HNUM FN					# <7>
do
    WASHASH="${BYPATH[${FN}]}"
    # did it find one? if not, it will be null
    if [[ -z $WASHASH ]]
    then
	ALTFN="${BYHASH[$HNUM]}"
	if [[ -z $ALTFN ]]
	then
	    printf '  <new>%s</new>\n' "$FN"
	else
	    printf '  <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN"
	    INUSE["$ALTFN"]='_'	# mark this as seen
	fi
    else
	INUSE["$FN"]='_'	# mark this as seen
	if [[ $HNUM == $WASHASH ]]
	then
	    continue;		# nothing changed;
	else
	    printf '  <changed>%s</changed>\n' "$FN"
	fi
    fi
done < "$B2ND"                                          # <8>

for FN in "${!INUSE[@]}"
do
    if [[ "${INUSE[$FN]}" == 'X' ]]
    then
        printf '  <removed>%s</removed>\n' "$FN"
    fi
done

printf '</filesystem>\n'

