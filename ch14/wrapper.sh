#!/bin/bash -
#
# Cybersecurity Ops with bash
# wrapper.sh
#
# Description: 
# Example of executing an encrypted "wrapped" script
#
# Usage:
# wrapper.sh
#    Enter the password when prompted
#

encrypted='U2FsdGVkX18WvDOyPFcvyvAozJHS3tjrZIPlZM9xRhz0tuwzDrKhKBBuugLxzp7T
MoJoqx02tX7KLhATS0Vqgze1C+kzFxtKyDAh9Nm2N0HXfSNuo9YfYD+15DoXEGPd'   #<1>

read -s word    #<2>

innerScript=$(echo "$encrypted" | openssl aes-256-cbc -base64 -d -pass pass:"$word")   #<3>

eval "$innerScript"   #<4>

