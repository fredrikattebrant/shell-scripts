# Shell script utilities for macosx and possibly other *nixes.

## About the pollJiraSoftwareVersions script
It requires an Atlassian Marketplace API token to run.
Here's how to run it from crontab on *macOS*:

```
#
# Check for new Jira Software versions
#
SHELL=/bin/sh
HOME=/Users/INSERT-USER
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
# Keep the following protected as user only readable (Note: don't use $HOME - it wont expand here):
ATLASSIAN_EMAIL_FILE=/Users/INSERT-USER/.somefolder/atlassian-api-email
ATLASSIAN_API_TOKEN_FILE=/Users/INSERT-USER/.somefolder/atlassian-api-token

# Check every workday at 10:15:
15 10 * * 1-5 $HOME/bin/pollJiraSoftwareVersions.sh
```
