#!/bin/bash -
#
# Cybersecurity Ops with bash
# logfuscate.sh
#
# Description: 
# Demonstration of logic obfuscation
#

f="$1"  #<1>

a() (
	b()
	{
		f="$(($f+5))"  #<5>
		g="$(($f+7))"  #<6>
		c  #<7>
	}

	b  #<4>
)

c() (
	d()
	{
		g="$(($g-$f))"  #<10>
		f="$(($f-2))"  #<11>
		echo "$f"  #<12>
	}
	f="$(($f-3))"  #<8>
	d  #<9>
)

f="$(($f+$2))"  #<2>
a  #<3>
