# Google Play Store listing

## App name
Tanga

## Short description (≤80 chars)
Run a Tang server on Android to auto-unlock LUKS-encrypted disks.

## Full description
Tanga runs a Tang (Network-Bound Disk Encryption) server on your Android device, so a Linux machine on the same network can automatically unlock a LUKS-encrypted disk — no passphrase at boot.

On Android 17 and newer, Tanga requests the "Nearby devices" permission so your Linux machine can reach the tang server running on your phone. The permission is used only for this local network connection; no data is sent to the internet.

This is a port of https://github.com/latchset/tang to Android.

Source code: https://github.com/gernotfeichter/tanga
