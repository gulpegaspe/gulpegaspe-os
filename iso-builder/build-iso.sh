#!/usr/bin/env bash
# Builds the gulpegaspe-os installer ISO. Run with: sudo bash build-iso.sh
set -euo pipefail

if [[ $# -gt 0 ]]; then
    cd "$1"
fi

mkdir -p output

podman build -t localhost/gulpegaspe-os-installer .

podman run --rm -it --privileged --pull=newer \
    -v ./output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    ghcr.io/osbuild/image-builder-cli:latest build \
    --output-dir /output \
    --bootc-ref localhost/gulpegaspe-os-installer \
    --bootc-default-fs btrfs \
    bootc-generic-iso

chown -R "${SUDO_UID:-0}:${SUDO_GID:-0}" output
find output -name '*.iso' -exec ls -lh {} \;
