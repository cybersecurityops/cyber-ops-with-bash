#!/bin/bash -
#
# Cybersecurity Ops with bash
# tagit.sh
#
# Description: 
# Place open and close tags around a string
#
# Usage:
# tagit.sh <tag> <string>
#   <tag> Tag to use
#   <string> String to tag
#

printf '<%s>%s</%s>\n' "${1}" "${2}" "${1}"
