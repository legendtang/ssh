FROM dock0/service
MAINTAINER akerl <me@lesaker.org>
RUN pacman -S --noconfirm --needed openssh

RUN mkdir -p /var/lib/ssh
RUN echo 'strong' > /var/lib/ssh/classes
RUN useradd -d /var/lib/ssh/cache -m ssh_key_sync
RUN su - ssh_key_sync -c 'git clone git://github.com/akerl/keys.git /var/lib/ssh/cache/repo'
ADD sshd_config /etc/ssh/sshd_config
ADD run /service/sshd/run
ADD sync /var/lib/ssh/sync

RUN groupadd remote
ENV ADMIN akerl
RUN useradd -d /home/$ADMIN -G remote -m $ADMIN
RUN passwd -d $ADMIN
