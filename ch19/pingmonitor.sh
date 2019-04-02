#!/bin/bash -
#
# Cybersecurity Ops with bash
# pingmonitor.sh
#
# Description: 
# Use ping to monitor host availability
#
# Usage:
# pingmonitor.sh <file> <seconds>
#   <file> File containing a list of hosts
#   <seconds> Number of seconds between pings
#

while true
do
 clear	
 echo 'Cybersecurity Ops System Monitor'
 echo 'Status: Scanning ...'
 echo '-----------------------------------------'
 while read -r ipadd 
 do
  ipadd=$(echo "$ipadd" | sed 's/\r//')   #<1>
  ping -n 1 "$ipadd" | egrep '(Destination host unreachable|100%)' &> /dev/null   #<2>
  if (( "$?" == 0 ))   #<3>
  then
   tput setaf 1	#<4>
   echo "Host $ipadd not found - $(date)" | tee -a monitorlog.txt   #<5>
   tput setaf 7
  fi
 done < "$1"
	
 echo ""
 echo "Done."

 for ((i="$2"; i > 0; i--))   #<6>
 do
  tput cup 1 0   #<7>
  echo "Status: Next scan in $i seconds"
  sleep 1
 done	
done
 
