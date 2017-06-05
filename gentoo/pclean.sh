#!/bin/bash
if [ -z "$1" ] ; then
	echo "Help: pclean.sh (env|keywords|unmask|use)"
	exit 1
elif [ "$1" = "env" ] ; then
	DIR="/etc/portage/package.env"
	FILE="env"
elif [ "$1" = "keywords" ] ; then
	DIR="/etc/portage/package.keywords"
	FILE="keywords"
elif [ "$1" = "unmask" ] ; then
	DIR="/etc/portage/package.unmask"
	FILE="unmask"
elif [ "$1" = "use" ] ; then
	DIR="/etc/portage/package.use"
	FILE="use"
else
	echo "Help: pclean.sh (env|keywords|unmask|use)"
	exit 1
fi

if [ -f $DIR/$FILE ] ; then
	while read -r i ; do
		[[ $i = \#* || -z $i ]] && continue
		str=$(echo "$i" | awk '{print $1}')
		if ! equery -q list "$str" &>/dev/null ; then
			echo "$str can be removed from $DIR/$FILE"
		fi
	done < $DIR/$FILE
else
	echo "$DIR/$FILE does not exist"
fi
