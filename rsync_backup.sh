#!/bin/bash
#
# rsync backup script
# source: http://www.howtogeek.com/175008/the-non-beginners-guide-to-syncing-data-with-rsync/
#
#set -xv

. $HOME/git/shell-scripts/ssh-agent-check-and-run.sh

MAILADDRESS=fredrik.attebrant@gmail.com

#BACKUP_PATH=backup/test/
BACKUP_PATH=backup/
BACKUP_ROOT=$HOME/$BACKUP_PATH
BACKUP_REMOTE=/media/RemoteFilesAttebrant/$BACKUP_PATH

TIMEFILE=$BACKUP_ROOT/time.txt
TIMEFILE2=$(echo $TIMEFILE | sed 's-time-time2-')
datetime=$(date +"%F-%H%M%S.%N")

LOGFILE=$BACKUP_ROOT/rsync-${datetime}.log
EXCLUDEFILE=$BACKUP_ROOT/config/exclude.txt

#copy old time.txt to time2.txt
yes | cp $TIMEFILE $TIMEFILE2

#overwrite old time.txt file with new time
echo $datetime > $TIMEFILE

#make the log file
echo "Creating; $LOGFILE"
echo "" > $LOGFILE

#rsync command
rsync -avzhPR \
  --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
  --delete \
  --stats \
  --log-file=$LOGFILE \
  --exclude-from $EXCLUDEFILE \
  --link-dest=/media/RemoteFilesAttebrant/backup/test/`cat ~/backup/test/time2.txt` \
  -e 'ssh -p 31700' $BACKUP_ROOT fredrik@romale.asuscomm.com:$BACKUP_REMOTE/${datetime}/

#don't forget to scp the log file and put it with the backup

scp -P 31700 \
  $BACKUP_ROOT/rsync-`cat $BACKUP_ROOT/time.txt`.log \
  fredrik@romale.asuscomm.com:$BACKUP_REMOTE/`cat $BACKUP_ROOT/time.txt`/rsync-`cat $BACKUP_ROOT/time.txt`.log

# done
echo "Backup complete at: $(date)" | mailx -s "Backup complete" $MAILADDRESS

