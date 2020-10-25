FROM alpine

LABEL maintainer="Snowind <jinks.tao@gmail.com>" \
      description="A simple git server with gitosis docker image"

ENV GIT_SERV_PATH /git-server

RUN apk add --no-cache openssh git git-fast-import python2 py2-setuptools \
  && rm /etc/motd \
  && ssh-keygen -A \
  && adduser -D git \
  && mkdir $GIT_SERV_PATH \
  && su git -c "mkdir /home/git/.ssh" \
  && sed -i 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' /etc/ssh/sshd_config

WORKDIR /git-server

RUN mkdir root repos \
  && ln -s $GIT_SERV_PATH/repos /home/git/repositories \
  && git clone https://github.com/res0nat0r/gitosis.git \
  && cd gitosis \
  && python setup.py install

# COPY git-shell-commands /home/git/git-shell-commands

# sshd_config file is edited for enable access key and disable access password
COPY entrypoint.sh entrypoint.sh

EXPOSE 22

VOLUME [ "$GIT_SERV_PATH/root", "$GIT_SERV_PATH/repos" ]

ENTRYPOINT ["sh", "entrypoint.sh"]
