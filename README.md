# gulpegaspe-os

## Locale (system)
```
localectl list-locales | grep it_
sudo localectl set-locale LANG=it_IT.UTF-8
```

## Dictionaries in Plasma KDE
```
flatpak config
sudo flatpak config --set languages "en;it"
flatpak config --set languages "en;it" --user
sudo flatpak config --set extra-languages "it"
flatpak config --set extra-languages "it" --user
flatpak update
```

Seleziona la versione (ultima raccomandata) per installare i dizionari con estensioni .aff e .dic che verranno letti dal motore di spelling di Plasma (System Settings -> Language & Time -> Spell Check)
```
flatpak install org.kde.Platform
```

## Keymap (system)
```
localectl list-keymaps | grep it
sudo localectl set-keymap it
```

## Timezone (system)
```
timedatectl list-timezones | grep -i rome
sudo timedatectl set-timezone Europe/Rome
```

## Fixes
Comment out root entry in /etc/fstab because it's already set up by bootc, avoiding an annoying console warning
```
sed -i '/ \/ /s/^/#/' /etc/fstab
```

## Add Flathub repository (obsolete)
```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

## Bootc switch (obsolete)
```
bootc switch ghcr.io/gulpegaspe/gulpegaspe-os
```
