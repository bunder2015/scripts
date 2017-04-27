#!/bin/bash


if [ -z $1 ] ; then
	echo "Help: pclean.sh (env|keywords|unmask|use)"
	exit 1
elif [ $1 = "env" ] ; then
	FILE="package.env"
elif [ $1 = "keywords" ] ; then
	FILE="package.keywords"
elif [ $1 = "unmask" ] ; then
	FILE="package.unmask"
elif [ $1 = "use" ] ; then
	FILE="package.use"
else
	echo "Help: pclean.sh (env|keywords|unmask|use)"
	exit 1
fi

while read i ; do
        [[ $i = \#* || -z $i ]] && continue
	str=$(echo $i | awk '{print $1}')
	equery -q list $str &>/dev/null
	if [ $? -ne 0 ] ; then
		echo "$str can be removed from $FILE"
        fi
done < /etc/portage/"$FILE"

