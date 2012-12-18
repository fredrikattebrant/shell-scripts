#!/bin/bash
#
# run "eclipse-38" Eclipse with Java 1.6
#
#set -xv

# default:
export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_26-b03-386.jdk/Contents/Home
export LAUNCHER_JAR=/Applications/dev/eclipse-381/plugins/org.eclipse.equinox.launcher_1.3.0.v20120522-1813.jar 

# override with command line options
case "$1" in
	"-java")
		JAVA_HOME="$2"
		shift 2
		;;
	"-launcher")
		LAUNCHER_JAR="$2"
		shift 2
		;;
esac

echo JAVA_HOME=$JAVA_HOME
echo LAUNCHER_JAR=$LAUNCHER_JAR
# verify
if [ ! -d "$JAVA_HOME" ]
then
	echo "*** Aborting: Can't find JAVA_HOME=$JAVA_HOME"
	exit 1
fi

if [ ! -f "$LAUNCHER_JAR" ]
then
	echo "*** Aborting: Can't find LAUNCHER_JAR=$LAUNCHER_JAR"
	exit 2
fi

java -showversion -XX:MaxPermSize=256m -Xms1024m -Xmx1024m -Xdock:icon=/Applications/eclipse/Eclipse.app/Contents/Resources/Eclipse.icns -XstartOnFirstThread -Dorg.eclipse.swt.internal.carbon.smallFonts -Dosgi.requiredJavaVersion=1.5 -jar $LAUNCHER_JAR
