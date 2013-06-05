#!/bin/bash

root="/data/fedora"
bb="$root/busybox"

echo "** Creating chroot filesystem"
adb shell mkdir -p $root

# Let's make sure we have our own busybox, so we don't depend on
# whatever random version a user may or may not have installed:
adb push system/xbin/busybox $root
adb shell chmod 755 $bb

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
	adb shell $bb tar xzvf /data/scratch/`basename $f` -C $root
	adb shell rm /data/scratch/`basename $f`
	caps="${f%%.tar.gz}.caps";
	if [ -r "$caps" ]; then
		adb push $caps $root/`basename $caps`
	fi
done

echo "** Cleaning up"

# to save a bit of space, we can nuke unneeded kernel modules (since
# they won't match the kernel we are using anyways)
adb shell rm -rf $root/lib/modules

adb shell umount /data/scratch
adb shell rmdir /data/scratch
adb shell rm $bb
