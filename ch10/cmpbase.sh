
# cmpbase.sh - compare baselines
#              and report on differences
#
# input: 2 files created by sha1sum
#
BASE=$1
B2ND=$2

declare -A BYPATH BYHASH INUSE 	# assoc. arrays

# load up the first file as the baseline
while read HNUM FN
do
    # TODO: check for a collision (prev. fn) on hash
    BYPATH["$FN"]=$HNUM
    BYHASH[$HNUM]="$FN"		# TODO: handle collisions
    INUSE["$FN"]="X"
done < $BASE

# see if each filename in the 2nd file is in
# the same place (path) as the 1st 
while read HNUM FN
do
    WASHASH="${BYPATH[${FN}]}"
    # did it find one? if not, it will be null
    if [[ -z $WASHASH ]]
    then
	ALTFN="${BYHASH[$HNUM]}"
	if [[ -z $ALTFN ]]
	then
	    echo "NewFile: $FN"
	else
	    echo "XFound: $FN"
	    echo "XFound: $FN $ALTFN"
	    INUSE["$ALTFN"]='_'	# mark this as seen
	fi
    else
	INUSE["$FN"]='_'	# mark this as seen
	if [[ $HNUM == $WASHASH ]]
	then
	    continue;		# nothing changed;
	else
	    echo "Changed: $FN"
	fi
    fi
done < $B2ND

for FN in "${!INUSE[@]}"
do
    if [[ "${INUSE[$FN]}" == 'X' ]]
    then
	echo "Removed: $FN"
    fi
done
