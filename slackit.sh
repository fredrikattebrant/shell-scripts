#!/bin/bash

SLACKER_USER=kfdd


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

slackit $@
