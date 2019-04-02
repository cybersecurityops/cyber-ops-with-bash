#!/bin/bash -
#
# Cybersecurity Ops with bash
# osdetect.sh
#
# Description: 
# Distinguish between MS-Windows/Linux/MacOS
#
# Usage: bash osdetect.sh
#   output will be one of: Linux MSWin macOS
#

if type -t wevtutil &> /dev/null           # <1>
then
    OS=MSWin
elif type -t scutil &> /dev/null           # <2>
then
    OS=macOS
else
    OS=Linux
fi
echo $OS
