
path=`/system/xbin/busybox dirname $0`
PS1="\[\033[1;36m\][\[\033[0;36m\]\u@\h\[\033[0;37m\]:\w\[\033[1;36m\]]\[\033[m\]$ \[\033[0;37;00m\]"
filesystems="/proc /dev"

# Stop android UI:
stop

# Make our filesystem not nosuid:
mount -o remount,suid /data

# Mount filesystems needed in chroot:
mount -o bind /proc $path/proc
mount -o bind /sys $path/sys
mount -t devtmpfs devtmpfs $path/dev
mkdir $path/dev/pts
mount -t devpts -o rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000 devpts $path/dev/pts
#mount -o bind /dev/pts $path/dev/pts
mount -t tmpfs tmpfs $path/tmp

# Start chroot:
PATH="/bin:/usr/bin:/sbin:/usr/sbin" /system/xbin/busybox chroot $path /enter-chroot.sh

sleep 1

# Unmount filesystems:
for f in /tmp /dev/pts /dev /system /sys /proc; do
  umount $path/$f
done

# re-start android UI:
start

