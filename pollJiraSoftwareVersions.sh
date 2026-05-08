#!/bin/bash
#
# Prereq:
# - Install terminal-notifier using homebrew (if on macOS)
# - Symlink this script and its companion pollJiraSoftwareVersions.py to $HOME/bin
# - Optionally run using a crontab entry (here check every weekday at 08:15):
#
# 15 8 * * 1,2,3,4,5 $HOME/bin/pollJiraSoftwareVersionOnMac.sh
#
#set -xv

verbose=""
num_versions=20
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
    [0-9]*)
      num_versions=$1
      shift
      ;;
    *)
      break
      ;;
  esac
done

# Load token from file when ATLASSIAN_API_TOKEN is not already set.
if [ -z "$ATLASSIAN_API_TOKEN" ] && [ -n "$ATLASSIAN_API_TOKEN_FILE" ]; then
  token_file="$ATLASSIAN_API_TOKEN_FILE"
  case "$token_file" in
    "~/"*)
      token_file="$HOME/${token_file#~/}"
      ;;
    '$HOME/'*)
      token_file="$HOME/${token_file#\$HOME/}"
      ;;
  esac
  if [ -r "$token_file" ]; then
    ATLASSIAN_API_TOKEN=$(tr -d '\r\n' < "$token_file")
  fi
fi

if [ -z "$ATLASSIAN_EMAIL" ] || [ -z "$ATLASSIAN_API_TOKEN" ]; then
  echo "Missing ATLASSIAN_EMAIL or ATLASSIAN_API_TOKEN environment variables."
  exit 1
fi

export ATLASSIAN_EMAIL ATLASSIAN_API_TOKEN

LAST_JIRA_VERSION_FILE=$HOME/.jira-sw-version-polled
PATH=/opt/homebrew/bin:/usr/local/bin:$PATH

touch $LAST_JIRA_VERSION_FILE # create if missing

CURRENT_JIRA_SOFTWARE_VERSION=$(cat $LAST_JIRA_VERSION_FILE)

if [ ! -z "$all" ]
then
  $HOME/bin/pollJiraSoftwareVersions.py -all $num_versions
  exit 0
fi

latest=$($HOME/bin/pollJiraSoftwareVersions.py $num_versions | head -1)

if [ ! -z "$verbose" ]
then
  echo "$latest"
fi

if [ "${CURRENT_JIRA_SOFTWARE_VERSION}" != "${latest}" ]; then
  if [ "$(uname)" == "Darwin" ]; then
    terminal-notifier -message "Version: $latest" -title "New Jira Software version"
  else
    echo "Version: $latest"
  fi
fi
