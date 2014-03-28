FROM dock0/arch
MAINTAINER akerl <me@lesaker.org>
ENV ADMIN akerl

RUN pacman -Syu --noconfirm --needed \
    base-devel cpio curl dnsutils gnupg gpgme htop inetutils iotop iproute2 \
    iputils less lockfile-progs lsof mtr net-tools nmap openssh perl python \
    python-pip ruby screen socat strace tar tcpdump tmux vim wget whois zsh

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

ADD known_hosts /home/$ADMIN/.ssh/known_hosts

ADD zshrc /home/$ADMIN/.zshrc

RUN chown -R $ADMIN:$ADMIN /home/$ADMIN
RUN passwd -d $ADMIN

ADD sshd_config /etc/ssh/sshd_config
ADD run /etc/sv/sshd/run
RUN ln -s /etc/sv/sshd /service/

ADD user-service /etc/sv/user/run
RUN mkdir /home/$ADMIN/.service
RUN ln -s /etc/sv/user /service/
RUN sed -i "s/ADMIN/$ADMIN/" /etc/sv/user/run

