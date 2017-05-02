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
#SPL_ROLLBACK_COMMIT=""
#ZFS_ROLLBACK_COMMIT=""
#
#SPL_TEMP_PATCHES=""
#ZFS_TEMP_PATCHES="https://patch-diff-github/raw/user/repo/pull/1234.patch
#https://github/user/repo/commit/a5s6d7f8.patch"

cd /home/testuser
if [ -f /home/testuser/zfs/scripts/zfs.sh ] ; then
        sudo /home/testuser/zfs/scripts/zfs.sh -u
fi
if [ -d /home/testuser/spl ] ; then
        rm -rf /home/testuser/spl
fi
if [ -d /home/testuser/zfs ] ; then
        rm -rf /home/testuser/zfs
fi

git clone $SPL_REPO
git clone $ZFS_REPO

cd /home/testuser/spl
git checkout $SPL_CHECKOUT
if [ -n "$SPL_ROLLBACK_COMMIT" ] ; then
	git reset --hard $SPL_ROLLBACK_COMMIT
fi
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
if [ -n "$ZFS_ROLLBACK_COMMIT" ] ; then
	git reset --hard $ZFS_ROLLBACK_COMMIT
fi
if [ -n "$ZFS_TEMP_PATCHES" ] ; then
	for f in $ZFS_TEMP_PATCHES ; do
		curl -s $f | git am
	done
fi
./autogen.sh
./configure --enable-debug
make
