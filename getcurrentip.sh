#/bin/bash
#
# From: https://medium.com/helderco/ip-from-the-command-line-722adafe7a00
#

wget -q -O - checkip.dyndns.com | grep -Po "[\d\.]+"
