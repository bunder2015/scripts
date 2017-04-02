#!/bin/bash

while read i ; do
        equery depends $i >> /dev/null
        if [ $? -eq 0 ]
                then
                        echo $i "can be deselected"
        fi
done < /var/lib/portage/world
