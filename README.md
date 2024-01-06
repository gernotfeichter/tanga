# tanga
> tanga=tang server on android; use android to unlock a LUKS encrypted disk of a linux machine

Guide to show the steps required to use NBDE (network bound disk encryption) to **automatically unlock** a **LUKS** encrypted partition, for example when an android device is on the same (WIFI) network as a linux machine.

> This guide is written for a Fedora linux machine. To use it on distributions systems, you will need to translate package manger/initial ram disk commands etc. to your target linux distribution! It will NOT be easy for the non-tech-affine, but it should be technically possible to run it on any linux distribution!

# setup

## android
1. download and install the Userland app from Google play store.
2. Launch an alpine session
3. Change the root user password: `sudo passwd root`
4. From your pc start an ssh session
Exchange Pixel-5 by the hostname or ip of your android phone!
```
ssh root@Pixel-5 -p 2022
```
Then install openrc and tang and enable tang to be started with the default target (and cahnge to the default target)
```
apk add openrc

apk add tang --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

rc-update add tang default

vi /etc/init.d/tang
```
change the line containing tang_address to look like:
```
: ${tang_address:="0.0.0.0"}
```
then proceed with:
```
mkdir /etc/bash
vi /etc/bash/bashrc
```
That file (`/etc/bash/bashrc`) should contain (workaround since openrc seems to not be able to properly restart services - at least in this environment)
```
sudo service tang restart

# The latter lines are only reuired if you do not want to keep tang running forever, I want it to stop after two minutes (120 seconds) automatically.
sleep 120
sudo service tang stop    
exit
```

## linux
1. Fill out the variables (change to your android IP) at the beginning of the script, then run the code:
   > If your android phone is the hotspot of your linux machine and the linux machine has the systemd service systemd-resolve (run `systemctl status systemd-resolved` to check), you may replace the IP address with the string _gatway!
   ```
   TANG_URL="http://Pixel-5:7500"
   ./test/encrypt-decrypt.sh "${TANG_URL}"
   ```
   Should print TEST SUCCESS!\
   If this is not the case, fix your tang server first.
2. Note, the following steps are mostly derived from https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/configuring-automated-unlocking-of-encrypted-volumes-using-policy-based-decryption_security-hardening#configuring-manual-enrollment-of-volumes-using-clevis_configuring-automated-unlocking-of-encrypted-volumes-using-policy-based-decryption.
3. install the clevis-luks package:
   `yum install clevis-luks`
4. note your disk, e.g. run `lsblk` and search for the string luks, then see the parent item (partition), for me it is `sda6`!
5. add tang server as another option (in addition to your existing passphrase) to unlock your LUKS partition:
   ```
   sudo clevis luks bind -d /dev/sda6 tang "{\"url\":\"${TANG_URL}\"}"
   ```
6. update your initramdisk to include networking and the newly installed clevis pin.
   ```
   sudo su
   dnf install clevis-dracut
   echo "hostonly_cmdline=yes" > /etc/dracut.conf.d/clevis.conf
   dracut -fv --regenerate-all
   ```
   > NOTE: While I mentioned WIFI in the intro, my linux machine needs to be connected via cable, since dracut seems to not support WIFI!
   > Luckily, at least the android phone can be on WIFI (on the same network/router).
   > Still, I'm looking forward to try other initrd management systems than dracut to get rid of this limitation!
7. reboot and hopefully your disk gets unlocked (at least after pressing enter on the plymouth screen without pasword)
8. You might want to get rid of plymouth to avoid even pressing enter!

# hint
You seem to be lazy and prefer not to type passwords.
Therefore, you might also be intersted in a similar solution for the PAM system:
https://github.com/gernotfeichter/alp

# why such a hacky solution
1. Initially I wanted to re-implement this in dart, but I saw that a lot of effort would need to be invested for software that already exists and works fine, but only on linux and not on android.
2. The next best though was: use dart ffi to port the C code to dart (which runs on android), here I faced two main obstacles
   - Tang has some non-small dependencies like the openssl project.
   - The dependencies normally do not use CmakeLists, which dart ffi requires. I gave up migrating openssl to CmakeLists after not working quickly.
   - Using compiled versions (instead of source versions) as dependencies also did not work, because for example those are compiled agains libc (linux) and android seems to use its own libc variant that is incompatible.
3. While a little bit hacky, the solution runs in a fully automated way once set up. Furthermore, the approach allows porting other/similar linux applications to android without altering them, which is awesome by itself.

# outlook
Setting up those clevis pins is not extremely trivial.
Eventually I consider creating a linux destribution that has the base setup already installed. Most likely that will be a small spin-off/add-on from/for some existing distro, will see what comes out and if I find enough motivation.

# tribute
to the main inventors/maintainers of most of the awesomeness that we make use of here:
- [Nathaniel McCallum](https://github.com/npmccallum) and Red Hat for the NBDE part.
- [Clemens Fruhwirth](https://clemens.endorphin.org/p/about-me.html) for the LUKS part.
- [Corbin Champion](https://github.com/corbinlc) for the UserLand app.
- [Julien Malka](https://github.com/JulienMalka) and [Camille Mondon](https://github.com/camillemndn) for implementing clevis/tang in NixOS.
- Michał Polański for maintaining the tang package in the alpine test repo.

Open source is a big community, for sure I forgot many other important people that are worth mentioning, just raise an issue!
