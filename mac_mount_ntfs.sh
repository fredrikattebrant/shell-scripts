#!/bin/sh
#
# Based on: http://forums.macrumors.com/showthread.php?t=785376
#
# Move to original mount_ntfs binary to mount_ntfs.orig
# Add this script - make sure to make it executable (chmod +x)
# It will invoke the mount_ntfs(.orig) with the read/write flag
#
/sbin/mount_ntfs.orig -o rw "$@“ 
