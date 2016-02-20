#!/bin/bash

#BACKUPDIR=/Users/fredrik/tmp
#REMOTEDIR=backup/test/texas.bilder.vart
BACKUPDIR=/Volumes/Bilder/Vart_Photos_Library.photoslibrary/
REMOTEDIR=backup/Bilder/Vart_Photos_Library.photoslibrary/

REMOTEPORT=4639
REMOTEUSER=fxo
REMOTEHOST=192.168.0.250

DATETIME=$(date +"%F-%H%M%S")
LOGDIR=$HOME/logs
LOG=$LOGDIR/backup_${DATETIME}.log

# go to the root of the source dir:
cd $BACKUPDIR

# backup from this (current) dir:
rsync -avzR \
  --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
  --log-file $LOG \
  --stats \
  -e "ssh -p $REMOTEPORT" . $REMOTEUSER@$REMOTEHOST:$REMOTEDIR


# send email report
tail -14 $LOG | Mail -s "Backup from texas to kfdd done: ${DATETIME}" backupstatus@kfdd.mine.nu

echo Mail sent

# start backup on texas
echo /home/fxo/bin/rsync_backup.sh | ssh -p $REMOTEPORT $REMOTEUSER@$REMOTEHOST at now +1 minutes
