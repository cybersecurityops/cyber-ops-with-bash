#!/bin/bash -
#
# Cybersecurity Ops with bash
# smtpconnect.sh
#
# Description: 
# Connect to a SMTP server and print welcome banner
#
# Usage:
# smtpconnect.sh <host>
#   <host> SMTP server to connect to
#

exec 3<>/dev/tcp/"$1"/25
echo -e 'quit\r\n' >&3
cat <&3
