#!/usr/bin/env bash

PARTS=$(grep "/boot/efi" /etc/fstab | awk '{print $1}' | cut -d'#' -f2)

if [ -z "$1" ] ; then
        echo "Need kernel to upgrade efi with."
        exit 1
fi

if [ -z "$PARTS" ] ; then
        echo "Add your EFI partitions to fstab and leave them commented out."
        exit 1
fi

for i in $PARTS ; do
        mount "$i" /boot/efi
        cp /boot/"$1".efi /boot/efi/EFI/gentoo
        umount "$i"
done

echo "Don't forget to update efibootmgr if necessary."

