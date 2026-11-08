# gulpegaspe-os

A personal, image-based Linux desktop built on [Fedora bootc](https://docs.fedoraproject.org/en-US/bootc/) with KDE Plasma.

The whole operating system is defined in a single `Containerfile`, built as an OCI container image and published to the GitHub Container Registry. Installed machines track that image and receive updates atomically: every update is a complete new deployment, and the previous one remains available for rollback.

## Features

- **Desktop:** KDE Plasma with Plasma Login Manager and a curated set of KDE applications (Dolphin, Kate, Konsole, Okular, Gwenview, Spectacle, Krita, Haruna, KDE Connect and more)
- **Browsers:** Firefox and Brave
- **Containers and virtualization:** Docker, Distrobox and virt-manager, plus the QEMU guest agent and SPICE agent for running the system itself as a VM
- **Flatpak:** preconfigured with the Flathub remote and integrated into System Settings
- **Security:** fingerprint authentication (fprintd) and KWallet unlocked at login
- **Tools:** BorgBackup, rclone, CryFS, FileZilla, Subversion
- **System tuning:** zram swap, systemd-oomd, and Wi-Fi power saving disabled through NetworkManager

## Repository structure

| Path | Description |
| --- | --- |
| `Containerfile` | Definition of the operating system image |
| `files/` | Configuration files copied into the image |
| `scripts/`, `systemd/` | Helper scripts and units (currently not used by the image) |
| `iso-builder/` | Custom Anaconda installer and ISO build script |
| `.github/workflows/build.yml` | CI workflow that builds and publishes the image |

## Building the image

### GitHub Actions

The image is built by the **Build -> gulpegaspe-os** workflow, which is started manually from the *Actions* tab. Each run publishes the image to `ghcr.io/gulpegaspe/gulpegaspe-os` with three tags:

- `latest`
- the short commit SHA (for example `52142c0`)
- the build date (for example `20261108`)

### Local build

```bash
podman build -t gulpegaspe-os .
```

## Installation

### From the installer ISO

The `iso-builder/` directory contains a custom Anaconda-based installer. To build the ISO:

```bash
cd iso-builder
sudo bash build-iso.sh
```

The resulting ISO is written to `iso-builder/output/`. The installer pulls the system image from `ghcr.io` during installation, so the target machine needs a working network connection.

### Switching an existing bootc system

```bash
sudo bootc switch ghcr.io/gulpegaspe/gulpegaspe-os:latest
```

## Updating

```bash
sudo bootc upgrade
```

Reboot to start the new deployment. If something goes wrong, return to the previous one with:

```bash
sudo bootc rollback
```

## Post-installation setup

The image ships with English as the only system language. The following steps configure Italian settings at the system level; each user can override them in Plasma System Settings.

### System locale

```bash
localectl list-locales | grep it_
sudo localectl set-locale LANG=it_IT.UTF-8
```

### Keyboard layout

```bash
localectl list-keymaps | grep it
sudo localectl set-keymap it
```

For the Plasma session, set the layout in **System Settings → Keyboard → Layouts**.

### Time zone

```bash
timedatectl list-timezones | grep -i rome
sudo timedatectl set-timezone Europe/Rome
```

For the Plasma session, set the time zone in **System Settings → Date & Time → Time Zone**.

### Spell-check dictionaries

Plasma's spell-check engine (Sonnet) also loads Hunspell dictionaries from the `org.kde.Platform` Flatpak runtime. This makes it possible to add dictionaries without modifying the image.

1. Add the language to the Flatpak configuration:

   ```bash
   flatpak config
   sudo flatpak config --set extra-languages "it"
   sudo flatpak update
   ```

2. Install the KDE runtime, which provides the `.aff` and `.dic` dictionary files:

   ```bash
   sudo flatpak install flathub org.kde.Platform
   ```

3. Pin the runtime so it is not removed by `flatpak uninstall --unused`, since no application depends on it:

   ```bash
   sudo flatpak pin runtime/org.kde.Platform/x86_64/<version>
   ```

The dictionaries are then available to all users in **System Settings → Language & Time → Spell Check**.

To restore the default configuration:

```bash
sudo flatpak config --unset extra-languages
sudo flatpak update
```

## Known issues

### Duplicate root entry in `/etc/fstab`

The root filesystem is already mounted by bootc, so the root entry in `/etc/fstab` causes a warning on the console at boot. Comment it out with:

```bash
sudo sed -i '/ \/ /s/^/#/' /etc/fstab
```

## Maintainer

Ivan Gasperoni
