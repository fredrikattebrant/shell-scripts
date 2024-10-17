#!/bin/bash
#
# Prereq:
# - Install terminal-notifier using homebrew
# - Symlink this script and its companion pollJiraSoftwareVersions.py to $HOME/bin
# - Optionally run using a crontab entry (here check every weekday at 08:15):
#
# 15 8 * * 1,2,3,4,5 $HOME/bin/pollJiraSoftwareVersionOnMac.sh
#
#set -xv

verbose=""

while [ $# -gt 0 ]
do
  case "$1" in
    -a*)
      all="true"
      shift
      ;;
    -v*)
      verbose="true"
      shift
      ;;
    *)
      break
      ;;
  esac
done

LAST_JIRA_VERSION_FILE=$HOME/.jira-sw-version-polled
PATH=/opt/homebrew/bin:/usr/local/bin:$PATH

touch $LAST_JIRA_VERSION_FILE # create if missing

CURRENT_JIRA_SOFTWARE_VERSION=$(cat $LAST_JIRA_VERSION_FILE)

if [ ! -z "$all" ]
then
  $HOME/bin/pollJiraSoftwareVersions.py 
  exit 0
fi

latest=$($HOME/bin/pollJiraSoftwareVersions.py | head -1)

if [ ! -z "$verbose" ]
then
  echo "$latest"
fi

if [ "${CURRENT_JIRA_SOFTWARE_VERSION}" != "${latest}" ]
then
        terminal-notifier -message "Version: $latest" -title "New Jira Software version"
fi
