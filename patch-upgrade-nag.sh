#!/bin/bash
# Patch out the "Upgrade to UniFi OS Server" nag modal
# Mount as:
#   -v ./patch-upgrade-nag.sh:/custom-cont-init.d/patch-upgrade-nag.sh
set -eu

SWAI_FILE=$(find /usr/lib/unifi/webapps/ROOT/app-unifi/react/js/ -name 'swai.*.js' 2>/dev/null | head -1)

if [ -z "${SWAI_FILE:-}" ]; then
    echo "[patch] swai.js not found, skipping upgrade nag patch"
    exit 0
fi

# Already patched?
if grep -q 'return !1&&r?' "$SWAI_FILE"; then
    echo "[patch] Already patched"
    exit 0
fi

# Verify target pattern exists before attempting patch
if ! grep -qP 'return n&&r\?.{1,30}aF\.Root' "$SWAI_FILE"; then
    echo "[patch] Pattern not found, UniFi bundle may have changed"
    exit 1
fi

# Use perl for lookahead support - replaces n&&r? only when followed by aF.Root
# This avoids hitting the unrelated radio table match which also contains n&&r?
perl -i -pe 's/return n&&r\?(?=.{1,30}aF\.Root)/return !1&&r?/' "$SWAI_FILE"

if grep -q 'return !1&&r?' "$SWAI_FILE"; then
    echo "[patch] Upgrade to UniFi OS Server nag removed successfully"
else
    echo "[patch] Patch verification failed"
    exit 1
fi