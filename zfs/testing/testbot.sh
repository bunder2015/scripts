#!/bin/bash

sudo /home/testuser/zfs/scripts/zfs.sh
/home/testuser/zfs/scripts/zfs-tests.sh -kvx
sudo /home/testuser/zfs/scripts/zfs.sh -u
