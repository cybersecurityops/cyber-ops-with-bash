#!/bin/bash -
#
# Rapid Cybersecurity Ops
# webdash.sh
#
# Description: 
# Create an information dashboard
# Heading
# --------------
# 1-line of output
# --------------
# 5 lines of output
# ...
# --------------
# column labels and then
# 8 lines of histograms
# ...
# --------------
#

# some important constant strings
UPTOP=$(tput cup 0 0)                               # <1>
ERAS2EOL=$(tput el)
REV=$(tput rev)		# reverse video
OFF=$(tput sgr0)	# general reset
SMUL=$(tput smul)	# underline mode on (start)
RMUL=$(tput rmul)	# underline mode off (reset)
COLUMNS=$(tput cols)	# how wide is our window
# DASHES='------------------------------------'
printf -v DASHES '%*s' $COLUMNS '-'                 # <2>
DASHES=${DASHES// /-}

#
# prSection - print a section of the screen 
#       print $1-many lines from stdin
#       each line is a full line of text 
#       followed by erase-to-end-of-line
#       sections end with a line of dashes
#
function prSection ()
{
    local -i i					    # <3>
    for((i=0; i < ${1:-5}; i++))
    do
        read aline
        printf '%s%s\n' "$aline" "${ERAS2EOL}"	    # <4>
    done
    printf '%s%s\n%s' "$DASHES" "${ERAS2EOL}" "${ERAS2EOL}"
}

function cleanup()				    # <5>
{
    if [[ -n $BGPID ]] 
    then
      kill %1					    # <6>
      rm -f $TMPFILE
    fi
} &> /dev/null					    # <7>

trap cleanup EXIT 

# launch the bg process
TMPFILE=$(tempfile)                                 # <8>
{ bash tailcount.sh $1 | \
  bash livebar.sh > $TMPFILE ; } &                  # <9>
BGPID=$!

clear
while true
do
    printf '%s' "$UPTOP"
    # heading:
    echo "${REV}Rapid Cyber Ops Ch. 12 -- Security Dashboard${OFF}" \
    | prSection 1
    #----------------------------------------
    {                                               # <10>
      printf 'connections:%4d        %s\n' \
            $(netstat -an | grep 'ESTAB' | wc -l) "$(date)" 
    } | prSection 1
    #----------------------------------------
    tail -5 /var/log/syslog | cut -c 1-16,45-105 | prSection 5 
    #----------------------------------------
    { echo "${SMUL}yymmdd${RMUL}"    \
            "${SMUL}hhmmss${RMUL}"  \
            "${SMUL}count of events${RMUL}"
      tail -8 $TMPFILE 
    } | prSection 9
    sleep 3
done
