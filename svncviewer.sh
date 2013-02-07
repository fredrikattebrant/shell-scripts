#!/bin/bash
#set -xv

user=NONE
host=NONE
port=22
remote=NONE
timeout=10

while [ $# -gt 0 ]
do
  echo "Args: $@"
  case "$1" in
	[1-9]*)
		timeout=$1
		shift
		;;
	-h*)
		host=$2
		shift 2
		;;
	-p*)
		port=$2
		shift 2
		;;
	-u*)
		user=$2
		shift 2
		;;
	*@*)
		remote=$1
		user=ok
		host=ok
		shift
		;;
	*)
		echo "!!! skipping: $1"
		shift
		;;
  esac
done

if [ "$host" = "NONE" -o "$user" = "NONE" ]
then
	echo "*** You must supply a host with -h hostname"
	echo "*** and a user with -u username"
	exit 1
fi

if [ "$remote" = "NONE" ]
then
	remote="$user@$host"
fi

echo Attempting to connect VNC to $host
echo Connection timeout: $timeout
xterm -title "Connect ssh tunnel for VNCviewer" -e ssh -C -N -L 5902:localhost:5901 -p $port $remote &
sleep $timeout
#$HOME/bin/vncviewer localhost:5902
#vncviewer /fullscreen localhost:5902
vncviewer localhost:5902
