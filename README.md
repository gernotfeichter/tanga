# tanga
> tanga = tang server on android; use your android device to unlock a LUKS encrypted disk of a linux machine

A [Tang](https://github.com/latchset/tang) server that runs **natively on Android**.
The Tang/NBDE protocol is implemented in Dart (with Flutter), so you can use your phone
to **automatically unlock** a **LUKS** encrypted partition when it is on the same
(WIFI) network as your linux machine.

While developed with good intentions, use it at your own risk!

# features
- Runs the Tang server directly on Android — no root, no container, no UserLand/Alpine.
- Standard Tang endpoints: `GET /adv`, `GET /adv/{kid}` and `POST /rec/{kid}`.
- Elliptic-curve keys (NIST P-521) are generated on first launch and persisted locally.
  Signing (`ES512`) and key-exchange (`ECMR`) keys never leave the device; the `kid` is the RFC 7638 thumbprint.
- Configurable **port** (default `7500`).
- **Auto-start** the server when the app launches.
- **Auto-stop** after a configurable number of minutes (`0` = never stop / forever).
- Shows the reachable URL(s) and a ready-to-paste `clevis luks bind ...` command.

# setup

## android
1. Install the **tanga** app on your android device — from the Google Play Store, or build it yourself (see [build from source](#build-from-source)).
2. Launch the app. The Tang server starts automatically on port `7500` and (by default) stops itself again after 2 minutes.
3. Optionally adjust **Port** and **Auto-stop after (minutes)** in the settings card (`0` = never stop).
4. The app shows the local address(es) of the running server and the exact command to bind a LUKS volume on the linux machine.

> Tip: for boot-time unlocking, the server must be reachable when the machine powers on.
> Either set auto-stop to `0`, or reopen the app shortly before booting (preferred - with auto-stop).

## linux

> This guide is written for the [hypnix](https://github.com/gernotfeichter/hypnix) linux distro.
> Use an AI tool to translate the steps to your other distro of choice!

Follow the [Clevis LUKS decryption guide](https://github.com/gernotfeichter/hypnix/blob/master/pills/2-clevis-luks-decryption.md) to bind your LUKS volumes to the tanga server.

# build from source
Prerequisites: Flutter (Dart 3) and the Android SDK.

```
# get dependencies
flutter pub get

# run on a specific connected device or emulator by also adding the -d "<device-name>",
# where device names can be listed with the command `flutter devices`
flutter run

# release builds
flutter build appbundle  # produces build/app/outputs/bundle/release/app-release.aab
```

## tests
```
flutter test            # unit & widget tests
./test/encrypt-decrypt.sh "${TANG_URL}"   # end-to-end interop test against clevis
```

# how it works
`tanga` now implements the Tang HTTP API directly in Dart:
- Advertisement (`GET /adv`) is served as a JWS (`application/jose+json`) signed with `ES512`; `GET /adv/{kid}` re-signs with the requested key, matching tang's `find_jws()`.
- Key exchange (`POST /rec/{kid}`) performs an `ECMR` (elliptic-curve key exchange) between the client JWK and the server's exchange key and returns the derived point as a JWK (`application/jwk+json`).
- Cryptography uses [pointycastle](https://pub.dev/packages/pointycastle); keys are P-521 and identified by their RFC 7638 thumbprint.

# hints
You seem to be lazy and prefer not to type passwords.
Therefore, you might also be interested in a similar solution for the PAM system:
https://github.com/gernotfeichter/alp, this is also part of the hypnix distro:
https://github.com/gernotfeichter/hypnix/blob/master/pills/1-android-linux-pam.md

# tribute
...to the main inventors/maintainers of most of the awesomeness that we make use of here:
- [Nathaniel McCallum](https://github.com/npmccallum) and Red Hat for the NBDE part.
- [Clemens Fruhwirth](https://clemens.endorphin.org/p/about-me.html) for the LUKS part.
- [Corbin Champion](https://github.com/corbinlc) for the UserLand app (this was used in the intial tanga version - git tag 1.0.0).
- [Julien Malka](https://github.com/JulienMalka) and [Camille Mondon](https://github.com/camillemndn) for implementing clevis/tang in NixOS.
- Michał Polański for maintaining the tang package in the alpine test repo. (this was used in the intial tanga version - git tag 1.0.0).

Open source is a big community, for sure I forgot many other important people that are worth mentioning, just raise an issue!

# license
[GPL-2.0](LICENSE)
