#!/bin/bash

# testbot.sh [runfile]
# runfile is optional, uses stock linux.run otherwise

# Drop caches
sudo echo 1 > /proc/sys/vm/drop_caches

# Load modules
sudo /home/testuser/zfs/scripts/zfs.sh

# Run the test suite using stock or custom .run
if [ -z "$1" ] ; then
	/home/testuser/zfs/scripts/zfs-tests.sh -kvx
else
	/home/testuser/zfs/scripts/zfs-tests.sh -kvx -r $1
fi

# Get failed tests
grep -a -e KILLED -e FAIL /var/tmp/test_results/current/log

# Unload modules
sudo /home/testuser/zfs/scripts/zfs.sh -u

# Drop caches
sudo echo 1 > /proc/sys/vm/drop_caches
