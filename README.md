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
ATLASSIAN_EMAIL=some@domain.com
# Keep the following protected as user only readable:
ATLASSIAN_API_TOKEN_FILE=$HOME/.somefolder/atlassian-api-token

# Check every workday at 10:15:
15 10 * * 1-5 $HOME/bin/pollJiraSoftwareVersions.sh
```
