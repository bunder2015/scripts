#!/bin/bash

while read -r i ; do
	if equery depends "$i" >> /dev/null ; then
		echo "$i can be deselected"
	fi
done < /var/lib/portage/world
