#!/bin/bash
#
# Script for switching dock configurations.
# Configure the Dock preferences and then copy ~/Library/Preferences/com.apple.dock.plist
# to the 'DIR' listed below. Configure ControlPlane to match.
#
#set -xv

caller=$(basename $0 .sh)

#echo Switching to: $caller >> ~/tmp/controlplane.log


LIB=$HOME/Library/Preferences
DIR=$HOME/Documents/macos/DockConfigurations
DOCKPLIST=com.apple.dock.plist

# dock preferences:
DUAL=com.apple.dock.mpb+p2715q.plist
DESKTOP=com.apple.dock.p2715q.plist
MACBOOK=com.apple.dock.mpb.plist

# check previous state - do we need to act?
STATEFILE=$HOME/.setdock

if [ -w $STATEFILE ]
then
  PREVIOUS_STATE="$(cat $STATEFILE)"
  if [ "$PREVIOUS_STATE" == "$caller" ]
  then
    # no change - do nothing
    exit 0
  fi
fi

# record the new state
echo "$caller" > $STATEFILE

case "$caller" in
    "setdock_extended")
      CONFIG=$DIR/$DUAL
      ;;
    "setdock_desktop")
      CONFIG=$DIR/$DESKTOP
      ;;
    "setdock_macbook")
      CONFIG=$DIR/$MACBOOK
      ;;
    "*")
      exit 0
esac

# copy the dock.plist
cp $CONFIG $LIB/$DOCKPLIST
#echo "Set: $CONFIG" >> ~/tmp/controlplane.log

# restart Dock:
killall Dock 

