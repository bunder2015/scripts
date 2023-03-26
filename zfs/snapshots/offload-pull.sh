#!/bin/bash

# Weekly ZFS incremental snapshot offload script (pull)
# Takes a snapshot from a remote machine and stores it to the local pool
# Note: in order for this script to work, an initial full pull must be manually performed

# Remote system (aka source)
RHOST="remotehost"
RPOOL="remotepool"
RDS="root
logs
home"

# Local system (aka destination)
LPOOL="mypool"
LDS="backup"

# Set to 1 for debugging purposes
VERBOSE=0

### Do not change anything below this line unless you know what you are doing! ###

# Script variables
THISWEEK=$(date +%V)
LASTWEEK=$(date +%V --date=-7days)

for SET in $RDS ; do
	if [ "$VERBOSE" -eq "1" ] ; then echo "ssh $RHOST zfs send -i $RPOOL/$SET@weekly-$LASTWEEK $RPOOL/$SET@weekly-$THISWEEK | zfs receive $LPOOL/$LDS/$RHOST/$SET@weekly-$THISWEEK" ; fi
	ssh "$RHOST" sudo zfs send -i "$RPOOL"/"$SET"@weekly-"$LASTWEEK" "$RPOOL"/"$SET"@weekly-"$THISWEEK" | sudo zfs receive "$LPOOL"/"$LDS"/"$RHOST"/"$SET"@weekly-"$THISWEEK"
	STATUS=$?
	if [ "$STATUS" -eq "0" ] ; then
		if [ "$VERBOSE" -eq "1" ] ; then echo "ssh $RHOST zfs destroy $RPOOL/$SET@weekly-$LASTWEEK" ; fi
		ssh "$RHOST" sudo zfs destroy "$RPOOL"/"$SET"@weekly-"$LASTWEEK"
	fi
done
