#!/bin/bash
#
# Checks if the ip address has changed since the last check. If so sends email.
# Depends on getcurrentip.sh so place that in /usr/local/bin
#
#set -xv

LAST_IP_FILE=$HOME/.last_ip_address

# Check for change:
current_ip=$(/usr/local/bin/getcurrentip.sh)

# Repeat check if no value
if [ -z "$current_ip" ]
then
	sleep 60
	current_ip=$(/usr/local/bin/getcurrentip.sh)
fi

# First time:
if [ ! -f "$LAST_IP_FILE" ]; then
	echo $current_ip > $LAST_IP_FILE
fi

LAST_IP="$(cat $LAST_IP_FILE)"
THEHOST=${HOSTNAME_ALIAS:-$(hostname)}
EMAILTO=${DEFAULT_EMAIL:-root}

if [ "$LAST_IP" != "$current_ip" ]; then
	echo "IP Changed from $LAST_IP to $current_ip"
	echo "IP Changed from $LAST_IP to $current_ip" | mail -s "Change IP on ${THEHOST}" ${EMAILTO}
#else 
#	# TODO Remove this logging as it will fill up the disk
#	echo "IP is same: $current_ip - $(date)"
fi
