# Installing Fedora F19 on Nexus 4
1. Put device in developer mode (if not done already), see for example:
  * http://geekcaves.blogspot.com/2013/05/how-to-unlock-developer-options-on.html
  * TODO, better link?
2. Install adb plus fastboot and optionally abootimg
  * for fedora host, `sudo yum install android-tools abootimg`
3. Run `./install-rootfs.sh`
4. Reboot device, hold down volume-down key to get to fastboot screen
5. At fastboot screen, `sudo fastboot boot boot/mako-boot.img`
  * This will not flash this kernel, so next time you reboot you are back to your original kernel.
6. Optional (but recommended), enable USB tethering so that you can connect to the device over ssh.
  * Settings -> More... -> Tethering & portable hotspot -> USB tethering
7. Connect to device: `adb shell`
8. On device, start chroot: `/data/fedora/start-chroot.sh`
  * NOTE: have a network connection, preferably WiFi.. on first boot, it will try to install X11, gnome-desktop, etc.

## NOTES:
1. Same filesystem/installer should really work for any snapdragon device with a320 or a220, but you would (probably) need a different kernel / boot.img
2. You need to have about 3GiB of free space on /data for the installation to work.. Possibly the  enter-chroot.sh script could be tweaked to install less than full @gnome-desktop for smaller installation size.

## TODO:
- [ ] figure out a way to fix ARGB vs ABGR issues that doesn't mess up colors in android

## Teh Codez
* kernel: git://github.com/freedreno/kernel-msm.git
  * branch: mako-kernel
  * use mako_rob_defconfig
