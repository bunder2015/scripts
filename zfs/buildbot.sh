#!/bin/bash

SPL_CHECKOUT="master"
ZFS_CHECKOUT="master"

cd /home/testuser
sudo /home/testuser/zfs/scripts/zfs.sh -u
rm -rf /home/testuser/spl /home/testuser/zfs

git clone http://www.github.com/zfsonlinux/spl
git clone http://www.github.com/bunder2015/zfs

cd /home/testuser/spl
git checkout $SPL_CHECKOUT
./autogen.sh
./configure
make

cd /home/testuser/zfs
git checkout $ZFS_CHECKOUT
./autogen.sh
./configure
make
