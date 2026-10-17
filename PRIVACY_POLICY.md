# Privacy Policy for Tanga

## Summary

Tanga runs a [Tang](https://en.wikipedia.org/wiki/Network-Bound_Disk_Encryption)
server on your Android device so that other machines on your network can use it
for network-bound disk encryption (NBDE). **Tanga does not collect, store,
transmit, or share any personal data.** It has no user accounts, no analytics,
no advertising, and no third-party tracking.

## What data the app handles

### Data you provide
You may optionally set two values, which
are stored **only locally on your device**:

- the network port the server listens on (default `7500`);
- the auto-stop timeout in minutes (`0` means never stop).

These settings are saved using Android's app-local storage
(`SharedPreferences`) and are removed when you uninstall the app. They are not
sent anywhere.

### Cryptographic material
To act as a Tang server, the app needs a cryptographic identity: a signing key
and an exchange key. On first use the app generates these keys and stores them
**only locally on your device** (Android app-local storage, `SharedPreferences`).
They are then reused on every subsequent start so that the server identity stays
stable and existing disk-unlock bindings keep working. These keys:

- are never transmitted to the developer or any third party;
- are only served to clients that connect to the running server on your local
  network, as part of the standard Tang protocol (`GET /adv`, `POST /rec/{kid}`);
- are removed when you uninstall the app or clear its storage (after which a new
  key pair is generated on next launch).

## Network access

Tanga requires the `INTERNET` permission solely to:

- run an HTTP server bound to your device's local network interfaces;
- read the device's local IP addresses so the app can display the address other
  machines should use.

The app itself does **not** contact any server on the internet. All traffic is
between your Android device and other devices you choose to connect on the same
local network. Nothing is sent to the developer or to any third party.

## Security

Tanga is intended to be used on networks you trust. While running, the server
exposes cryptographic advertisement and key-exchange material to devices that can
reach it on your network. We recommend using the auto-stop feature (a non-zero
timeout) and stopping the server when it is not needed. The app transmits no data
over the public internet.

### Data safety declaration (Google Play Console)

For the Play Console "Data safety" form, Tanga can be declared as:

- **Data collected:** None
- **Data shared:** None
- **Data types:** No data types collected
- **Security practices:** Data is not transmitted off the device by the app
- **Data deletion:** Not applicable (no data collected)

