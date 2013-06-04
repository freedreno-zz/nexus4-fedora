#!/bin/bash

root="/data/fedora"

echo "** Creating chroot filesystem"
adb shell mkdir -p $root

# adb is made of fail.. what we'd *like* to do is pipe contents of
# a tar file into an untar cmd on the device via it's stdin.. but
# adb doesn't properly support redirecting stdin to the invoked
# process.  So instead we have to push the compressed tar files to
# tmpfs and extract 'em from there:

echo "** Setting up scratch"
adb shell mkdir /data/scratch
adb shell mount -t tmpfs tmpfs /data/scratch

for f in rootfs/*.tar.gz; do
	echo "**** Pushing to scratch: $f"
	adb push $f /data/scratch
	echo "**** Extracting: $f"
	adb shell /system/xbin/busybox tar xzvf /data/scratch/`basename $f` -C $root
	adb shell rm /data/scratch/`basename $f`
	caps="${f%%.tar.gz}.caps";
	if [ -r "$caps" ]; then
		adb push $caps $root/`basename $caps`
	fi
done

adb shell umount /data/scratch
adb shell rmdir /data/scratch
