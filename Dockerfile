FROM akerl/arch
MAINTAINER akerl <me@lesaker.org>
EXPOSE 22
ENV ADMIN akerl

RUN pacman -S --noconfirm --needed \
    base-devel curl dnsutils gnupg gpgme htop inetutils iotop iproute2 iputils \
    less lockfile-progs lsof mtr net-tools nmap openssh perl python python-pip \
    ruby screen socat sqlite strace tar tcpdump tmux vim wget whois zsh

RUN groupadd remote
RUN useradd \
    --shell /usr/bin/zsh \
    --home-dir /home/$ADMIN \
    --groups remote \
    --create-home \
    $ADMIN

RUN git clone git://github.com/akerl/scripts.git /opt/scripts
RUN /opt/scripts/script_sync /opt/scripts

RUN git clone git://github.com/ingydotnet/....git /home/$ADMIN/...
ADD dotdotdot.conf /home/$ADMIN/.../conf

RUN git clone git://github.com/akerl/keys.git /opt/keys
RUN mkdir /home/$ADMIN/.ssh
RUN /opt/scripts/key_sync /opt/keys/default /home/$ADMIN/.ssh/authorized_keys noconfirm

ADD zshrc /home/$ADMIN/.zshrc

RUN chown -R $ADMIN:$ADMIN /home/$ADMIN

ADD sshd_config /etc/ssh/sshd_config
ADD run /etc/sv/sshd/run
RUN ln -s /etc/sv/sshd /service/
