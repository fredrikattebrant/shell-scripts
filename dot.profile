#
# .profile for mac osx
#
# rename from 'dot.profile' to '.profile' and place in your $HOME directory
#

MYUSER=fredrik # replace with your user

PATH=/opt/subversion/bin:$PATH:/usr/local/git/bin:$HOME/bin:$PATH
export PATH

JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME

#PS1="\h:\W \u\$ "
PS1="\h:\W \$ "

alias lf='ls -F'
alias ll='ls -lF'
alias think='xtt think; think'
alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias ppjava='pp_java -2pAt4'

function xtt 
{
#
# Usage:	xtt { title }	# default is username@hostname, except for $MYUSER
#
#PS1='$ '
if [ "$1" != "" ]
then
	title="$1"
else
	if [ "$USER" = "$MYUSER" ]
	then
		title=`uname -n`
	else
		title="`whoami`@`uname -n`"
	fi
fi

echo -n "]0;$title"
}

# enable "next command" with ctrl-o:
stty -iexten
