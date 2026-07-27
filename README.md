# gulpegaspe-os

## Locale
```
localectl list-locales | grep it_
sudo localectl set-locale LANG=it_IT.UTF-8
```

## Keymap
```
localectl list-keymaps | grep it
sudo localectl set-keymap it
```

## Timezone
```bash
timedatectl list-timezones | grep -i rome
sudo timedatectl set-timezone Europe/Rome
```

## Fixes
Comment out root entry in /etc/fstab because it's already set up by bootc, avoiding an annoying console warning
```bash
sed -i '/ \/ /s/^/#/' /etc/fstab
```

## Add Flathub repository (obsolete)
```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
