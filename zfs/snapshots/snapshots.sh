#!/bin/bash

# Hourly / Daily / Weekly ZFS snapshot script
# Keeps 24 hours of hourly snapshots, 7 days of daily snapshots
# Weekly snapshots get removed by offload-pull.sh from remote server
# Note: requires user with sudo privileges

# Set POOL/DS as needed
POOL="mypool"
DS="root
logs
home"

# Set to 1 for debugging purposes
VERBOSE=0

### Do not change anything below this line unless you know what you are doing! ###

# Script variables
THISHOUR=$(date +%H)
HOURTODAY=$(date +%m%d%H)
HOURYESTERDAY=$(date +%m%d%H --date=-24hours)
TODAY=$(date +%m%d)
DAYOFWEEK=$(date +%w)
THISWEEK=$(date +%V)
LASTWEEKDAY=$(date +%m%d --date=-7days)

for SET in $DS ; do
	# Daily at midnight
	if [ "$THISHOUR" -eq "00" ] ; then
		# Weekly Sundays at midnight
		if [ "$DAYOFWEEK" -eq "0" ] ; then
			if [ "$VERBOSE" -eq "1" ] ; then echo "zfs snapshot $POOL/$SET@weekly-$THISWEEK" ; fi
			sudo zfs snapshot "$POOL"/"$SET"@weekly-"$THISWEEK"
		else
			if [ "$VERBOSE" -eq "1" ] ; then echo "zfs snapshot $POOL/$SET@daily-$TODAY" ; fi
			sudo zfs snapshot "$POOL"/"$SET"@daily-"$TODAY"
			if [ "$VERBOSE" -eq "1" ] ; then echo "zfs destroy $POOL/$SET@daily-$LASTWEEKDAY" ; fi
			sudo zfs destroy "$POOL"/"$SET"@daily-"$LASTWEEKDAY"
		fi
	else
		# Hourly
		if [ "$VERBOSE" -eq "1" ] ; then echo "zfs snapshot $POOL/$SET@hourly-$HOURTODAY" ; fi
		sudo zfs snapshot "$POOL"/"$SET"@hourly-"$HOURTODAY"
		if [ "$VERBOSE" -eq "1" ] ; then echo "zfs destroy $POOL/$SET@hourly-$HOURYESTERDAY" ; fi
		sudo zfs destroy "$POOL"/"$SET"@hourly-"$HOURYESTERDAY"
	fi
done
