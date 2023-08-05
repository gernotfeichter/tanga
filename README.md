# tanga
> tanga=tang server on android; use android to unlock a LUKS encrypted disk of a linux machine

Guide to show the steps required to use NBDE (network bound disk encryption) to **automatically unlock** a **LUKS** encrypted partition, for example when an android device is on the same (WIFI) network as a linux machine.

> This guide is written for a Fedora linux machine. To use it on distributions systems, you will need to translate package manger/initial ram disk commands etc. to your target linux distribution! It will NOT be easy for the non-tech-affine, but it should be technically possible to run it on any linux distribution!

# setup

## android
(very short draft)
1. Install https://play.google.com/store/apps/details?id=tech.ula&hl=en_US&pli=1
2. Start the distribution of your choice.
3. Connect via ssh, e.g.: `sh root@10.0.0.3 -p 2022`
4. Install tang.\
   If it does not work via the package manager, compile from source:
   https://github.com/latchset/tang
5. Since we cannot run stuff via systemd, we need to manually initialize keys, e.g.:
   ```
   mkdir -p /var/db/tang
   sudo jose jwk gen -i '{"alg":"ES512"}' -o /var/db/tang/newsig.jwk
   sudo jose jwk gen -i '{"alg":"ECMR"}' -o /var/db/tang/newexc.jwk
   ```
6. Start tang:
   ```
   /usr/lib/tangd --port 1080 --listen /var/db/tang
   ```
   > for my self-compiled version, it was /usr/libexec/tangd --port 1080 --listen /var/db/tang
   > the port must be above 1000 due to android restrictions!

## linux
1. Fill out the variables (change to your android IP) at the beginning of the script, then run the code:
   > If your android phone is the hotspot of your linux machine and the linux machine has the systemd service systemd-resolve (run `systemctl status systemd-resolved` to check), you may replace the IP address with the string _gatway!
   ```
   TANG_URL="http://10.0.0.3:1080"
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
   yum install clevis-dracut
   echo "hostonly_cmdline=yes" > /etc/dracut.conf.d/clevis.conf
   dracut -fv --regenerate-all
   ```
   > NOTE: While I mentioned WIFI in the intro, my linux machine needs to be connected via cable, since dracut seems to not support WIFI!
   > Luckily, at least the android phone can be on WIFI (on the same network/router).
   > Still, I'm looking forward to try other initrd management systems than dracut to get rid of this limitation!
7. reboot and hopefully your disk gets unlocked (at least after pressing enter on the plyouth screen without pasword)
8. You might want to get rid of plymouth to avoid even pressing enter!

# tribute
to the main inventors/maintainers of most of the awesomeness that we make use of here:
- Nathaniel McCallum https://github.com/npmccallum for the NBDE part.
- Clemens Fruhwirth https://clemens.endorphin.org/p/about-me.html for the LUKS part.

Open source is a big community, for sure I forgot many other important people, just raise an issue!