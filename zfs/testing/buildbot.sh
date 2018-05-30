#!/bin/bash

###
# THESE MUST BE SET
###
ZFS_REPO="https://github.com/zfsonlinux/zfs"
ZFS_CHECKOUT="master"

###
# THESE ARE OPTIONAL
###
#ZFS_ROLLBACK_COMMIT="a5c6d7f8"
#ZFS_TEMP_PATCHES="https://patch-diff-github/raw/user/repo/pull/1234.patch https://github/user/repo/commit/a5c6d7f8.patch"

# Cleanup - unload old modules
cd /home/testuser
if [ -f /home/testuser/zfs/scripts/zfs.sh ] ; then
        sudo /home/testuser/zfs/scripts/zfs.sh -u
fi

# Cleanup - remove old repo
if [ -d /home/testuser/zfs ] ; then
        rm -rf /home/testuser/zfs
fi

# Fetch - obtain new repo
git clone $ZFS_REPO

# zfs - apply patches and/or rollback
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

# zfs - build phase
./autogen.sh
./configure --enable-debug
make
