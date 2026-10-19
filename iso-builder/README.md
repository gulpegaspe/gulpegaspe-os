sudo podman pull ghcr.io/gulpegaspe/gulpegaspe-os:latest

sudo podman build -t ghcr.io/gulpegaspe/gulpegaspe-os --disable-compression=false  .

sudo podman build -t gulpegaspe-os-installer .

sudo podman run --rm -it --privileged --pull=newer -v ./output:/output -v /var/lib/containers/storage:/var/lib/containers/storage ghcr.io/osbuild/image-builder-cli:latest build --output-dir /output     --bootc-ref localhost/gulpegaspe-os-installer --bootc-default-fs btrfs bootc-generic-iso
