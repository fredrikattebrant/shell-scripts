#!/bin/bash
#
# Utility for Atlassian Forge development
#
# Sets the app-id in manifest.yml as read from ~/.forge-app-id
#

forgeAppIdFile="$HOME/.forge-app-id"

if [ ! -f "$forgeAppIdFile" ]
then
  cat << EOH

Add your forge app-id to the file: $forgeAppIdFile
Format is one line like:

app/abcd1234-f0zz-zz99-0000-7qw49ert34xxx

EOH
  exit 1
fi

usage() {
  cat << EOH

  "${basename $0} [path/to/manifest.yml]"
EOH
}

ForgeAppId="$(cat $forgeAppIdFile)"
echo "Your forge App ID: $ForgeAppId"
ManifestYmlFile="${1:-manifest.yml}"
echo "Manifest yml => ${ManifestYmlFile}"

# Use GNU sed for inline support:
gsed -i "s:app/.*:${ForgeAppId}:" "$ManifestYmlFile"
