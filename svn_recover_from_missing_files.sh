#!/usr/bin/bash
#
# svn_recover_from_missing_files.sh
# -dry[run] don't perform any operations, just show which files will be recovered to 'deleted' state
#
# Ref: http://fredrikattebrant.blogspot.co.uk/2015/01/xtext-and-svn-recovering-from-missing.html
#
# Recovers 'missing' files making them 'deleted'.
#

dryrun=false
verbose=false

function usage {
cat << EOH
Usage: $(basename $0) [-dry[run]] [-verbose] path_to_svn_folder
EOH
}

function printMissing {
	echo "Found the following missing files:"
	echo
	cat MISSING.txt
	echo
}

while [ $# -gt 0 ]
do
  case "$1" in
    -dry*)
      dryrun=true
      shift
      ;;
    -h*|--h*|-?)
      usage
      exit 0
      ;;
	-verbose)
	  verbose=true
	  shift
	  ;;
    *)
      break
    esac
done

if [ -z "$1" ]
then
  # use current directory as svn folder to scan
  svnfolder=.
else
  svnfolder="$1"
fi

svn status $svnfolder | grep '^! ' | awk '{print $2}' | sed 's-\\-/-g' > MISSING.txt
filecount=$(cat MISSING.txt | wc -l)
if [ $filecount -eq 0 ]
then
	echo "Found no missing files"
	exit 0
fi
echo "Found: ${filecount} missing files"
if [ "$verbose" = "true" ]
then
	printMissing
fi

if [ "$dryrun" = "false" ]
then
  echo "Reverting $(cat MISSING.txt | xargs echo) ..."
  cat MISSING.txt | xargs svn revert
  echo "Deleting $(cat MISSING.txt | xargs echo) ..."
  cat MISSING.txt | xargs svn delete
  echo "Cleaning up ..."
  rm MISSING.txt
  echo "Done."
  echo ""
  echo "svn status:"
  svn status $svnfolder
else
  echo "Only a dryrun - nothing changed."
  rm MISSING.txt
fi
