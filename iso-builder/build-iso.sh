#!/usr/bin/env bash
# Builds the gulpegaspe-os installer ISO.
#
# Usage: sudo bash build-iso.sh [--offline]
#
#   --offline   Embed the system image in the ISO, so the installation
#               does not need a network connection (larger ISO).
set -euo pipefail

PAYLOAD_REF="ghcr.io/gulpegaspe/gulpegaspe-os:latest"
INSTALLER_REF="localhost/gulpegaspe-os-installer"
BUILDER_REF="ghcr.io/osbuild/image-builder-cli:latest"

offline=false
case "${1:-}" in
    "") ;;
    --offline) offline=true ;;
    *) echo "Usage: sudo bash $0 [--offline]" >&2; exit 1 ;;
esac

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)." >&2
    exit 1
fi

# Always work from the directory containing this script
cd "$(dirname "$(readlink -f "$0")")"
mkdir -p output

builder_args=()
if $offline; then
    payload_source="containers-storage"
    echo ">> Pulling ${PAYLOAD_REF} to embed it in the ISO"
    podman pull "$PAYLOAD_REF"
    builder_args+=(--bootc-installer-payload-ref "$PAYLOAD_REF")
else
    payload_source="registry"
fi

echo ">> Building installer image (payload source: ${payload_source})"
podman build --pull=newer \
    --build-arg PAYLOAD_REF="$PAYLOAD_REF" \
    --build-arg PAYLOAD_SOURCE="$payload_source" \
    -t "$INSTALLER_REF" .

echo ">> Building ISO"
podman run --rm --privileged --pull=newer \
    -v ./output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    "$BUILDER_REF" build \
    --output-dir /output \
    --bootc-ref "$INSTALLER_REF" \
    --bootc-default-fs btrfs \
    "${builder_args[@]}" \
    generic-iso

chown -R "${SUDO_UID:-0}:${SUDO_GID:-0}" output
find output -name '*.iso' -exec ls -lh {} \;
