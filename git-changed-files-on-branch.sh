#!/bin/bash
#
# 20191128 12:24 1.3 Use current branch as default
# 20191120 13:08 1.2 Support comparison vs origin/master
# 20191119 09:22 1.1 Lists changed projects with option for every file
# 20191115 15:22 1.0 Lists every changed file on the given branch
#
# Uncomment to "trace" execution:
#set -xv

function usage {
cat << EOH
Usage: $(basename $) [-v] [branch]

List changes made on branch vs origin/develop

Changes are listed per Eclipse project.

Options:
 -v List every changed file.
 -m Compare against origin/master instead.

If no branch is given, the current branch is used.

EOH
}

function filter {
	awk -F/ '{print $1, $2}' | sort -u | sed 's- -/-'
}

function currentBranch {
	git branch | egrep '^\* ' | awk '{print $2}'
}

remotebranch=origin/develop

while [ $# -gt 0 ]
do
  case "$1" in
    -v*|--v*)
      verbose=true
      shift
      ;;
    -m*|--m*)
      remotebranch=origin/master
      shift
      ;;
    -h*|--h*|-?)
      usage
      exit 0
      ;;
    -*)
      usage
      exit 1
      ;;
    *)
      break
    esac
done

if [ ! -z "$1" ]
then
	branch=$1
else
	branch=$(currentBranch)
fi

if [ ! -z "$verbose" ]
then
	git diff --name-only $branch $(git merge-base $branch $remotebranch)
else
	git diff --name-only $branch $(git merge-base $branch $remotebranch) | filter
fi



