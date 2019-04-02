# Cybersecurity Ops with bash
# countem.awk
#
# Description: 
# Count the number of instances of an item using awk
#
# Usage:
# countem.awk < inputfile
#

awk '{ cnt[$1]++ }
END { for (id in cnt) {
        printf "%d %s\n", cnt[id], id
      }
    }'
