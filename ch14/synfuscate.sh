#!/bin/bash -
#
# Cybersecurity Ops with bash
# synfuscate.sh
#
# Description: 
# Demonstration of syntax script obfuscation
#

a ()   #<1>
{

	local a="Local Variable a"   #<2>
	echo "$a"
}

a="Global Variable a"   #<3>
echo "$a"

a
