FROM quay.io/fedora/fedora-bootc:latest
LABEL maintainer="Ivan Gasperoni"

COPY ./scripts/first-boot-setup.sh /usr/local/bin/first-boot-setup.sh
COPY ./systemd/first-boot-setup.service /usr/lib/systemd/system/first-boot-setup.service

RUN rmdir /opt && ln -s -T /var/opt /opt \
    dnf -y install dnf5-plugins && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
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
        langpacks-it && \
    authselect enable-feature with-fingerprint && \
    chmod +x /usr/local/bin/first-boot-setup.sh && \
    systemctl enable first-boot-setup.service && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    dnf -y autoremove && \
    dnf clean all && \
    find /var/log -type f ! -empty -delete && \
    bootc container lint

    #dnf -y install spice-vdagent && \
    #flatpak update -y && \
    #flatpak install -y io.github.flattool.Warehouse && \
    #flatpak uninstall --unused -y && \
    #rm -rf /var/cache/* /var/lib/dnf/* /var/tmp/* /tmp/* && \
