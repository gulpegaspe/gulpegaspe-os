FROM quay.io/fedora/fedora-bootc:latest
LABEL maintainer="Ivan Gasperoni"

COPY ./scripts/set-wifi-powersave.sh /usr/local/bin/set-wifi-powersave.sh
COPY ./systemd/set-wifi-powersave-off.service /usr/lib/systemd/system/set-wifi-powersave-off.service

RUN rmdir /opt && mkdir /var/opt && ln -s -T /var/opt /opt && \
    dnf -y install dnf5-plugins && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    dnf copr enable -y bieszczaders/kernel-cachyos && \
    dnf -y remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra && \
    dnf -y install kernel-cachyos kernel-cachyos-devel-matched && \
    dnf -y install \
        plasma-workspace \
        plasma-login-manager \
        plasma-nm \
        plasma-nm-openvpn \
        dolphin \
        kate \
        spectacle \
        kcalc \
        krita \
        gwenview \
        okular \
        konsole \
        plasma-print-manager \
        plasma-firewall \
        krdp \
        keepsecret \
        ark \
        kde-gtk-config \
        pam-kwallet \
        kscreen \
        kde-connect \
        plasma-systemmonitor \
        bluedevil \
        kinfocenter \
        langpacks-en \
        brave-browser \
        distrobox \
        docker \
        runc \
        virt-manager \
        flatpak-kcm \
        firefox \
        flatpak \
        borgbackup \
        fprintd-pam \
        NetworkManager-wifi \
        splix \
        rclone \
        vlc \
        pciutils \
        openh264 \
        filezilla \
        langpacks-it && \
    authselect enable-feature with-fingerprint && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    dnf -y autoremove && \
    dnf clean all && \
    find /var/log -type f ! -empty -delete && \
    chmod +x /usr/local/bin/set-wifi-powersave.sh && \
    systemctl enable set-wifi-powersave-off.service && \
    bootc container lint

    #chmod +x /usr/local/bin/fix-bootc-system.sh && \
    #systemctl enable fix-bootc-system.service && \
    #dnf -y install spice-vdagent && \
    #flatpak update -y && \
    #flatpak install -y io.github.flattool.Warehouse && \
    #flatpak uninstall --unused -y && \
    #rm -rf /var/cache/* /var/lib/dnf/* /var/tmp/* /tmp/* && \
