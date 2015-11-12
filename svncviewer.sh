#!/bin/bash
#set -xv

user=NONE
host=NONE
geometry=""
port=22
reconnect=NO
remote=NONE
timeout=15

#Determine VNC viewer executable
case "$(uname -s)" in
	"Darwin")
		VNCVIEWER="/Applications/Chicken.app/Contents/MacOS/Chicken"
		;;
	*)
		# Default: viewer on PATH:
		VNCVIEWER="vncviewer"
		;;
esac

while [ $# -gt 0 ]
do
  #echo "Args: $@"
  case "$1" in
	[1-9]*)
		timeout=$1
		shift
		;;
	-h*)
		host=$2
		shift 2
		;;
        -g*)
                geometry="-geometry $2"
                shift 2
                ;;
	-p*)
		port=$2
		shift 2
		;;
	-r*)
                reconnect=YES
		shift 1
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
	-?)
		cat << EOHELP
Usage: 
  To setup ssh tunnel and launch VNC, use one of:
    $(basename $0) [-h host] [-u username] [-g geometry] [timeout (e.g. 30)] [-p ssh_port]
    $(basename $0) [-g geometry] [timeout (e.g. 30)] [-p ssh_port] [user@hostname]

  To reconnect VNC using an existing ssh tunnel:
    $(basename $0) -r[econnect]

  Note: Use either "user@hostname" or "-h hostname -u user"

EOHELP
		exit 0
		;;
	*)
		echo "!!! skipping: $1"
		shift
		;;
  esac
done

if [ "$reconnect" = "YES" ]
then 
    "$VNCVIEWER" $geometry localhost:5902
    exit 0
fi

if [ "$host" = "NONE" -o "$user" = "NONE" ]
then
	echo "*** You must supply a host with -h hostname"
	echo "*** and a user with -u username"
        echo ""
        echo "$(basename $0) -? will print help"
        echo ""
	exit 1
fi

if [ "$remote" = "NONE" ]
then
	remote="$user@$host"
fi

echo Attempting to connect VNC to $remote
echo Connection timeout: $timeout
xterm -geometry 50x10  -title "Connect ssh tunnel for VNCviewer" -e ssh -C -N -L 5902:localhost:5901 -p $port $remote &
#sleep $timeout
let t=0
while [ $t -lt $timeout ]
do
	echo -n "."
	sleep 1
	let t=t+1
done
echo 
echo "Launching vncviewer"
#$HOME/bin/vncviewer localhost:5902
#vncviewer /fullscreen localhost:5902
"$VNCVIEWER" $geometry localhost:5902
