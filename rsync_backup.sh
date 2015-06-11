#!/bin/bash
#
# rsync backup script
# source: http://www.howtogeek.com/175008/the-non-beginners-guide-to-syncing-data-with-rsync/
# 

BACKUPDIR_LOCAL=$BACKUPDIR
BACKUPDIR_REMOTE=/media/RemoteFilesAttebrant
REMOTE_USER=fredrik
REMOTE_HOST=romale.asuscomm.com

#copy old time.txt to time2.txt
yes | cp $BACKUPDIR_LOCAL/time.txt $BACKUPDIR_LOCAL/time2.txt

#overwrite old time.txt file with new time
echo $(date +”%F-%I%p”) > $BACKUPDIR_LOCAL/time.txt

#make the log file
echo “” > $BACKUPDIR_LOCAL/rsync-$(date +”%F-%I%p”).log

#rsync command
rsync -avzhPR --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --delete \
  --stats --log-file=$BACKUPDIR_LOCAL/rsync-$(date +”%F-%I%p”).log \
  --exclude-from '~/exclude.txt' --link-dest=/home/geek2/files/$(cat $BACKUPDIR_LOCAL/time2.txt) \
  -e 'ssh -p 12345' $BACKUPDIR_LOCAL $REMOTE_USER@$REMOTE_HOST:$BACKUPDIR_REMOTE/$(date +”%F-%I%p”)/

#don’t forget to scp the log file and put it with the backup
scp -P 12345 $BACKUPDIR_LOCAL/rsync-$(cat $BACKUPDIR_LOCAL/time.txt).log \
  $REMOTE_USER@REMOTE_HOST:/home/geek2/files/$(cat $BACKUPDIR_LOCAL/time.txt)/rsync-$(cat $BACKUPDIR_LOCAL/time.txt).log

