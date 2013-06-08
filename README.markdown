# Installing Fedora F19 on Nexus 4
1. Put device in developer mode (if not done already), see for example:
  * http://geekcaves.blogspot.com/2013/05/how-to-unlock-developer-options-on.html
  * TODO, better link?
2. Install adb plus fastboot and optionally abootimg
  * for fedora host, `sudo yum install android-tools abootimg`
3. Reboot device, hold down volume-down key to get to fastboot screen
4. At fastboot screen, `sudo fastboot boot boot/mako-boot.img`
  * This will not flash this kernel, so next time you reboot you are back to your original kernel.
5. Enable USB tethering so that you can connect to the device over ssh.
  * Settings -> More... -> Tethering & portable hotspot -> USB tethering
6. Run `install-rootfs.sh`
7. Connect to device: `adb shell`
8. On device, start chroot: `/data/fedora/start-chroot.sh`
  * NOTE: have a network connection, preferably WiFi.. on first boot, it will try to install X11, gnome-desktop, etc.

## NOTES:
1. Same filesystem/installer should really work for any snapdragon device with a320 or a220, but you would (probably) need a different kernel / boot.img
2. You need to have about 3GiB of free space on /data for the installation to work.. Possibly the  enter-chroot.sh script could be tweaked to install less than full @gnome-desktop for smaller installation size.
3. You might need to disable data on your phone (if you have a SIM installed while you do this) for network to work under fedora (which is required during the first boot, to install the rest of @gnome-desktop, etc).  It is probably a good idea anyways to disable data or remove SIM while you install, just to ensure that it doesn't try to download several hundred megabytes of packages over using your data plan.
4. The MSM display driver is, umm, quirky.. to avoid problems with the display getting stuck off or backlight-disabled, make sure the screen is on when you run start-chroot.sh.  Also ensuring the display is on when you start-chroot.sh will make sure wifi is up.
5. To activate the hot-corner to get the overview mode (ie. what you get with the super (windows) key on a desktop), swipe up and to the left into the top left corner of the display.

## Extra stuff I install
This gives you everything you need to rebuild freedreno (libdrm, ddx, mesa) from git:
yum install @development-tools automake autoconf xorg-x11-server-devel libX11-devel libXext-devel libtool libXau-devel libXdamage-devel libXfixes-devel libXxf86vm-devel libxcb-devel pixman-devel xorg-x11-proto-devel xorg-x11-util-macros gcc-c++ vim strace git tig htop
yum-builddep mesa-libGL

## TODO:
- [ ] figure out a way to fix ARGB vs ABGR issues that doesn't mess up colors in android
- [ ] mounts don't always get cleaned up properly when exiting
- [ ] debug issue w/ gnome-terminal (xterm can be installed as work-around for now)
- [ ] touchscreen/input crash in xserver (input event overflow?)

## Teh Codez
* kernel: git://github.com/freedreno/kernel-msm.git
  * branch: mako-kernel
  * use mako_rob_defconfig
