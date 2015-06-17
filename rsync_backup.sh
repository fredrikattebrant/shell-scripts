#!/bin/bash
#
# rsync backup script
# source: http://www.howtogeek.com/175008/the-non-beginners-guide-to-syncing-data-with-rsync/
# 

BACKUPDIR_LOCAL=$HOME/backup
BACKUPDIR_REMOTE=/media/RemoteFilesAttebrant/backup
REMOTE_USER=fredrik
REMOTE_HOST=romale.asuscomm.com

#copy old time.txt to time2.txt
cp $BACKUPDIR_LOCAL/time.txt $BACKUPDIR_LOCAL/time2.txt

#overwrite old time.txt file with new time
BACKUP_TIME=$(date +%F-%I%p)
echo $BACKUP_TIME > $BACKUPDIR_LOCAL/time.txt

#make the log file
echo “” > $BACKUPDIR_LOCAL/rsync-$(date +%F-%I%p).log

#rsync command
rsync -avzhPR --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --delete \
  --stats --log-file=$BACKUPDIR_LOCAL/rsync-$(date +”%F-%I%p”).log \
  --exclude-from '~/exclude.txt' --link-dest=/home/geek2/files/$(cat $BACKUPDIR_LOCAL/time2.txt) \
  -e 'ssh -p 12345' $BACKUPDIR_LOCAL $REMOTE_USER@$REMOTE_HOST:$BACKUPDIR_REMOTE/$(date +”%F-%I%p”)/

#dont forget to scp the log file and put it with the backup
scp -P 12345 $BACKUPDIR_LOCAL/rsync-${BACKUP_TIME}.log \
  $REMOTE_USER@REMOTE_HOST:$BACKUPDIR_REMOTE/${BACKUP_TIME}/rsync-${BACKUPDIR_REMOTE}.log

