#!/bin/bash

###
# THESE MUST BE SET
###
SPL_REPO="https://github.com/zfsonlinux/spl"
SPL_CHECKOUT="master"

ZFS_REPO="https://github.com/zfsonlinux/zfs"
ZFS_CHECKOUT="master"

###
# THESE ARE OPTIONAL
###
#SPL_TEMP_PATCHES=""
#ZFS_TEMP_PATCHES="https://patch-diff-github/raw/user/repo/pull/1234.patch
#https://github/user/repo/commit/a5s6d7f8.patch"

cd /home/testuser
sudo /home/testuser/zfs/scripts/zfs.sh -u
rm -rf /home/testuser/spl /home/testuser/zfs

git clone $SPL_REPO
git clone $ZFS_REPO

cd /home/testuser/spl
git checkout $SPL_CHECKOUT
if [ -n "$SPL_TEMP_PATCHES" ] ; then
	for f in $SPL_TEMP_PATCHES ; do
		curl -s $f | git am
	done
fi
./autogen.sh
./configure --enable-debug
make

cd /home/testuser/zfs
git checkout $ZFS_CHECKOUT
if [ -n "$ZFS_TEMP_PATCHES" ] ; then
	for f in $ZFS_TEMP_PATCHES ; do
		curl -s $f | git am
	done
fi
./autogen.sh
./configure --enable-debug
make
