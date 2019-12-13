#!/bin/bash

# setup PATH to include slacker:
PATH=$PATH:/usr/local/bin

#BACKUPDIR=/Users/fredrik/tmp
#REMOTEDIR=backup/test/texas.bilder.vart
BACKUPDIR=/Volumes/Bilder/Vart_Photos_Library.photoslibrary/
REMOTEDIR=backup/Bilder/Vart_Photos_Library.photoslibrary/

REMOTEPORT=4639
REMOTEHOMEDIR=home
REMOTEUSER=fxo
REMOTEHOST=192.168.0.250

DATETIME=$(date +"%F-%H%M%S")
LOGDIR=$HOME/logs
LOG=$LOGDIR/backup_${DATETIME}.log
TEMPSTATUS=/tmp/$(basename $0).$$
SLACKER_USER=texas

### Functions
#
# slackit "Message text" file_with_path
#
function slackit
{
  # slack the status
  export SLACK_TOKEN="$(cat $HOME/.slacktoken)"
  if [ $# -eq 2 ]
  then
    echo "$1 \`\`\`$(cat $2)\`\`\`" | slacker -c backups -n $SLACKER_USER
  else
    echo "$1" | slacker -c backups -n $SLACKER_USER
  fi
}

### MAIN ###
#

if [ ! -r $BACKUPDIR ]
then
  slackit "Aborting backup - Backup dir missing: $BACKUPDIR"
  exit 1
fi

echo "Starting backup at: $DATETIME"

# run even weeks only:
week=$(date +%U)
if [ $(($week % 2)) != 0 ]; then 
    slackit "odd week - skipping backup"
    exit 0
fi

# go to the root of the source dir:
cd $BACKUPDIR

# backup from this (current) dir:
rsync -avzR \
  --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
  --log-file $LOG \
  --stats \
  -e "ssh -p $REMOTEPORT" . $REMOTEUSER@$REMOTEHOST:$REMOTEDIR


# slack a report
tail -13 $LOG > $TEMPSTATUS
slackit "Backup from texas to kfdd done: ${DATETIME}" $TEMPSTATUS

# start backup on the remote host
echo /$REMOTEHOMEDIR/$REMOTEUSER/bin/rsync_backup.sh | ssh -p $REMOTEPORT $REMOTEUSER@$REMOTEHOST at now +1 minutes

slackit "Backup scheduled on kfdd"

rm $TEMPSTATUS
### END ###
