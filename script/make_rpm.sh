#!/bin/bash

# Make a rpm package of tcpdive based on specific kernel version.

# Kernel Version
KERNEL_VER="2.6.32-431.17.1.el6.x86_64"
KERNEL_NAME=`echo $KERNEL_VER|sed 's/\.x86_64//'`

if [ ! -d "/lib/modules/$KERNEL_VER" ]; then
	echo "kernel-devel-$KERNEL_VER.rpm is not installed!"
	exit 1
fi

# Tool Version
TOOL_VER="1.0"
TOOL_RELEASE="stable"
DIR=`dirname $0`
CMD_FILE="$DIR/tcpdive"
SPEC_FILE="$DIR/tcpdive.spec"
MODULE="tcpdive.ko"

# Revise cmd file
sed -i "4s/.*/TOOL_VER=$TOOL_VER/" $CMD_FILE
sed -i "5s/.*/TOOL_RELEASE=$TOOL_RELEASE/" $CMD_FILE
sed -i "7s/.*/KERNEL=$KERNEL_VER/" $CMD_FILE

# Revise spec file
sed -i "1s/.*/%define kversion $KERNEL_NAME/" $SPEC_FILE
sed -i "4s/.*/Version:	$TOOL_VER/" $SPEC_FILE
sed -i "5s/.*/Release:	$TOOL_RELEASE/" $SPEC_FILE

# Compile module
# use "../tcpdive.sh -h" to see all options supported.
$DIR/../tcpdive.sh -m -L -H > /dev/null
if [[ $? -ne 0 || ! -f $MODULE ]]; then
	echo "Compile $MODULE failed!"
	exit 1
fi

# Build rpm
RPMROOT="/root/rpmbuild"
TAR_NAME="tcpdive-$KERNEL_NAME-$TOOL_VER"

mkdir -p $TAR_NAME
mv $MODULE $TAR_NAME
cp $CMD_FILE $TAR_NAME
tar -czf $TAR_NAME.tar.gz $TAR_NAME/
rm -rf $TAR_NAME

mkdir -p $RPMROOT/SOURCES
mv $TAR_NAME.tar.gz $RPMROOT/SOURCES

rpmbuild -bb $SPEC_FILE &> $RPMROOT/log
if [ $? -eq 0 ]; then
	echo "Make rpm package ok!"
	mv $RPMROOT/RPMS/x86_64/${TAR_NAME}*.rpm .
	rm -f $RPMROOT/RPMS/x86_64/tcpdive*
else
	echo "Make rpm package failed!"
	cat $RPMROOT/log
fi

rm -f $MODULE
rm -f $RPMROOT/log
rm -rf $RPMROOT/SOURCES/${TAR_NAME}*
rm -rf $RPMROOT/BUILD/${TAR_NAME}*


