FROM dock0/service
MAINTAINER akerl <me@lesaker.org>
ENV ADMIN akerl
RUN pacman -S --noconfirm --needed gnupg gpgme openssh
RUN groupadd remote
RUN useradd -d /home/$ADMIN -G remote -m $ADMIN
RUN git clone git://github.com/akerl/scripts.git /opt/scripts
RUN /opt/scripts/script_sync /opt/scripts
RUN git clone git://github.com/akerl/keys.git /opt/keys
RUN mkdir /home/$ADMIN/.ssh /root/.ssh
RUN /opt/scripts/key_sync /opt/keys/default /home/$ADMIN/.ssh/authorized_keys noconfirm
RUN chown -R $ADMIN:$ADMIN /home/$ADMIN
RUN passwd -d $ADMIN
ADD sshd_config /etc/ssh/sshd_config
ADD run /service/sshd/run

