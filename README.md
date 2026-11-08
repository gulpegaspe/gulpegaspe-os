# gulpegaspe-os

## Locale (system)
```
localectl list-locales | grep it_
sudo localectl set-locale LANG=it_IT.UTF-8
```

## Dictionaries in Plasma KDE
Primo step é quello di configurare le lingue 
```
flatpak config
sudo flatpak config --set extra-languages "it"
flatpak update
```

Secondo step é l'installazione vera e propria dei dizionari con estensioni .aff e .dic che verranno letti dal motore di spelling di Plasma (System Settings -> Language & Time -> Spell Check)
```
flatpak install org.kde.Platform
```
Per ripristinare la situazione di default
```
sudo flatpak config --unset extra-languages
flatpak update
```
Ora tutti gli utenti del sistema avranno a disposizione i dizionari impostati/installati

## Keymap (system)
```
localectl list-keymaps | grep it
sudo localectl set-keymap it
```
Per impostare il layout di tastiera a livello di Plasma KDE usare li impostazioni di sistema (System Settings -> Keyboard -> Layouts)

## Timezone (system)
```
timedatectl list-timezones | grep -i rome
sudo timedatectl set-timezone Europe/Rome
```
Per impostare il timezone a livello di Plasma KDE usare li impostazioni di sistema (System Settings -> Date & Time -> Time Zone)

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
