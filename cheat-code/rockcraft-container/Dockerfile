FROM ubuntu:jammy

ENV container=docker \
    PATH="/snap/bin:/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin" \
    init=/lib/systemd/systemd

RUN apt update && apt install -y systemd snapd \
    && apt clean \
    && rm -rf /var/lib/apt/lists

# remove systemd 'wants' triggers and UTMP updater
RUN rm -f \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/multi-user.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp-runlevel.service

# remove everything except tmpfiles setup in sysinit target
RUN find \
    /lib/systemd/system/sysinit.target.wants \
    \( -type f -or -type l \) -and -not -name '*systemd-tmpfiles-setup*' \
    -delete

COPY entrypoint.sh entrypoint-wrapper.sh /usr/local/bin/
COPY entrypoint.service /etc/systemd/system/entrypoint.service

# enable the services we care about
RUN systemctl enable snapd.service \
    && systemctl enable snapd.socket \
    && systemctl enable entrypoint.service \
    # Don't use graphical.target
    && systemctl set-default multi-user.target

# Ensure docker sends the shutdown signal that systemd expects
STOPSIGNAL SIGRTMIN+3

WORKDIR /workdir

ENTRYPOINT ["/usr/local/bin/entrypoint-wrapper.sh"]
