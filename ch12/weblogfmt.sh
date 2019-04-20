#!/bin/bash -
#
# Cybersecurity Ops with bash
# weblogfmt.sh
#
# Description: 
# Read in Apache web log and output as HTML
#
# Usage:
# weblogfmt.sh input.file > output.file
#

function tagit()
{
	printf '<%s>%s</%s>\n' "${1}" "${2}" "${1}"
}

#basic header tags
echo "<html>"                                            # <1>
echo "<body>"
echo "<h1>$1</h1>"   #title

echo "<table border=1>"   #table with border
echo "<tr>"   #new table row
echo "<th>IP Address</th>"  #column header
echo "<th>Date</th>"
echo "<th>URL Requested</th>"
echo "<th>Status Code</th>"
echo "<th>Size</th>"
echo "<th>Referrer</th>"
echo "<th>User Agent</th>"
echo "</tr>"

while read f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12plus    # <2>
do
	echo "<tr>"
	tagit "td" "${f1}"
	tagit "td" "${f4} ${f5}"                        # <3>
	tagit "td" "${f6} ${f7}"
	tagit "td" "${f9}"
	tagit "td" "${f10}"
	tagit "td" "${f11}"
	tagit "td" "${f12plus}"
	echo "</tr>"
done < $1

#close tags
echo "</table>"
echo "</body>"
echo "</html>"

