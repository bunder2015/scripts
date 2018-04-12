#!/bin/bash

# Drop caches
sudo /home/testuser/dropcaches.sh

# Load modules
sudo /home/testuser/zfs/scripts/zfs.sh

# Run the test suite
/home/testuser/zfs/scripts/zfs-tests.sh -kvx

# Unload modules
sudo /home/testuser/zfs/scripts/zfs.sh -u

# Drop caches
sudo /home/testuser/dropcaches.sh
