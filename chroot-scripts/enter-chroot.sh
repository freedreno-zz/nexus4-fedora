#!/bin/bash

hostname n4
chmod +x /usr/bin/resize
resize
chmod 666 /dev/kgsl-3d0 /dev/dri/card0 /dev/fb0
mkdir -p /run/dbus
rm -f rm /var/run/messagebus.pid

# needed to make polkitd happy:
mount -t tmpfs -o rw,nosuid,nodev,noexec,seclabel,mode=755 tmpfs /sys/fs/cgroup
mkdir -p /sys/fs/cgroup/systemd/machine

###########################################################
# Some first-time setup we need to do..

# TODO setcap/getcap not working yet.. somthing missing in
# kernel config?
## we loose file caps by extracting rootfs from a tarball.. on
## first boot we have to fix this up:
#for f in /*.caps; do
#	
#done

# need to generate keys for sshd:
if ! [ -r /etc/ssh/ssh_host_rsa_key ]; then
	echo "**** Running sshd-keygen"
	sshd-keygen
fi

# TODO is there a better way to check if @gnome-desktop is
# installed??
if ! [ -x /usr/sbin/gdm ]; then
	echo "**** Installing desktop"
	yum install xorg-x11-server-Xorg xorg-x11-drv-evdev ConsoleKit ConsoleKit-x11 @gnome-desktop
	glib-compile-schemas /usr/share/glib-2.0/schemas/
	# run first-boot graphical setup:
	#/bin/xinit /bin/firstboot-windowmanager /bin/initial-setup -- /bin/Xorg :9 -ac -nolisten tcp
	# TODO first-boot graphical stuff blows up in some anaconda logging
	# code.. for now create user manually:
	echo "**** Creating user:"
	while `true`; do
		echo "enter desired username:"
		read name
		if [ "x$name" != "x" ]; then
			useradd $name && passwd $name && break
		fi
	done
fi

###########################################################
# Start daemons..

echo "**** Starting sshd"
/sbin/sshd

echo "**** Starting dbus"
dbus-daemon --system

echo "**** Starting polkitd"
/usr/lib/polkit-1/polkitd --no-debug &

echo "**** Starting gdm"
gdm &

bash
