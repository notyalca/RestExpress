#! /bin/bash
#

if [ -z "$RESTEXPRESS_HOME" ]; then
	RESTEXPRESS_HOME=~/local/RestExpress
fi

NAME_LWR=`echo $1 | awk {'print tolower($1)'}`

rm -rf $1
mkdir $1
cp -r $RESTEXPRESS_HOME/* $1
cp $RESTEXPRESS_HOME/.classpath $1
cp $RESTEXPRESS_HOME/.project $1
cd $1

# Update build.xml
sed -i .orig s/KickStart/$1/g build.xml

# Rename the 'kickstart' directories
mv src/java/com/kickstart/ src/java/com/$1/
# packages
find src/java/com/$1 -name '*.java' | xargs grep -l kickstart | xargs sed -i .orig s/kickstart/$NAME_LWR/g
# class names
find src/java/com/$1 -name '*.java' | xargs grep -li kickstart | xargs sed -i .orig s/[Kk]ick[Ss]tart/$1/g
# file names
mv src/java/com/$1/KickstartEnvironment.java src/java/com/$1/$1Environment.java
mv src/java/com/$1/service/KickStartController.java src/java/com/$1/service/$1Controller.java

#if {-z 'test/java/com/kickstart/'}
#    mv test/java/com/kickstart/ test/java/com/$1/
#    find test/java/com/$1 -name '*.java' | xargs grep -l kickstart | xargs sed -i .orig s/kickstart/$1/g
#fi

# Clean up
find . -name '*.orig' | xargs rm

# Done
echo $1 RestExpress service suite created.