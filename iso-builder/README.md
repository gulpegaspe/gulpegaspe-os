sudo podman pull ghcr.io/gulpegaspe/gulpegaspe-os:latest

sudo podman build -t ghcr.io/gulpegaspe/gulpegaspe-os --disable-compression=false  .

sudo podman run --rm -it --privileged --pull=newer \
  -v ./:/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  -v ./config.toml:/config.toml:ro \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type anaconda-iso \
  --rootfs btrfs \
  ghcr.io/gulpegaspe/gulpegaspe-os
