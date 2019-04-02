# Cybersecurity Ops with bash
# vtjson.awk
#
# Description: 
# Search a JSON file for VirusTotal malware hits
#
# Usage:
# vtjson.awk <json file>
#   <json file> File containing results from VirusTotal
#

FN="${1:-Calc_VirusTotal.txt}"
sed -e 's/{"scans": {/&\n /' -e 's/},/&\n/g' "$FN" |     # <1>
awk '
NF == 9 {                                       # <2>
    COMMA=","
    QUOTE="\""                                  # <3>
    if ( $3 == "true" COMMA ) {                 # <4>
        VIRUS=$1                                # <5>
        gsub(QUOTE, "", VIRUS)                  # <6>

        RESLT=$7
        gsub(QUOTE, "", RESLT)
        gsub(COMMA, "", RESLT)

        print VIRUS, "- result:", RESLT
    }
}'

