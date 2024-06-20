#!/usr/bin/env bash

# screenshot concatenator
# Dave Foster (@daf)
# idea by KingPunk of the Gentoo Forums
# slightly modified by @bunder2015
#
# dependancies:
# wmctrl
# imagemagick with png support


# program options
# ./catshot.sh <outputfile>
# 	<outputfile> the file you want catshot to dump to
#		     with the extension .png

# setup things
# you may change SHOOTCMD to scrot if you want, but since it
# requires montage anyway, you'll prolly have import
SHOOTCMD="import -window root"
# you should change TILEGEOM to your particular setup, in the
# form of (Columns)x(Rows)
TILEGEOM="3x2"
# delay between each shot that is taken during execution, this
# should probably be always set to 1
DELAY=1

# you probably don't need to change anything past this point 

# get filename if it is set
if [ $# -eq 1 ]
then
	OUTFILE="$1.png"
else
	OUTFILE="screenshot1.png"
fi

# grab info from wmctrl
STARTDESK=`wmctrl -d | grep \* | cut -d ' ' -f1`
DESKS=`wmctrl -d | wc -l`;
DESKSIZE=`wmctrl -d | head -n 1 | cut -d ' ' -f5`

# initializing variable
IMGLIST=

# shoot each desk
for ((i=0; i< DESKS ; i++))
do
	wmctrl -s $i
	sleep $DELAY
	echo "Shooting desk $i..."
	$SHOOTCMD $i.png
	IMGLIST="$IMGLIST $i.png"
done

# go back to start desk
wmctrl -s $STARTDESK

# stitch em together
echo "Concatenating images, please wait."
echo "Using layout: $TILEGEOM"
echo "To outfile: $OUTFILE"
montage -adjoin -geometry $DESKSIZE -tile $TILEGEOM $IMGLIST $OUTFILE 
echo "If no errors occured, $OUTFILE is complete."

# remove temp files
echo "Cleaning up..."
for ((i=0; i< DESKS ; i++))
do
	rm $i.png
done

echo "Done!"
