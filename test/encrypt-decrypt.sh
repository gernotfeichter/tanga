#!/usr/bin/env bash

set -e

# Encrypts and then decrypts a string using a provided tang server.
# Why am I doing this? Normally I want to use tang for NBDE (network bound disk encryption/decyption) for a LUKS encrypted disk.
# However, to test if the tang server is correctly working (e.g. after running it on android),
# I can as well just test this quickly this via simple string encryption/decryption code.

# Usage: ./encrypt-decrypt.sh <TANG-URL>
# Example: ./encrypt-decrypt.sh 

TANG_URL="${1:-http://10.0.0.3:1080}"

echo TANG_URL="${TANG_URL}"
CONFIG="{\"url\":\"${TANG_URL}\"}"
clevis encrypt tang "${CONFIG}" -y < test/PLAINTEXT > /tmp/encrypt-decrypt-test-secret.jwe
DECRYPTED="$(clevis decrypt tang < /tmp/encrypt-decrypt-test-secret.jwe)"

[ "${DECRYPTED}" == "PLAINTEXT" ] && echo "TEST SUCCESS!" && exit 0

echo "TEST FAILED!" && exit 1
