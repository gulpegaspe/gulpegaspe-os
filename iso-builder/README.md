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

  
sudo podman run --rm --privileged -it -v ./:/output -v /var/lib/containers/storage:/var/lib/containers/storage ghcr.io/osbuild/image-builder build bootc-installer --bootc-ref localhost/gulpegaspe-os-installer --bootc-default-fs btrfs --bootc-installer-payload-ref ghcr.io/gulpegaspe/gulpegaspe-os:latest
