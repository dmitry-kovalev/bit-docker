FROM node:slim
MAINTAINER Dmitry Kovalev <dkovalev@yandex.ru>

#Install ssh and bit dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y vim openssh-server curl apt-transport-https \
    gcc make python g++ git sudo \
    ca-certificates openssl gnupg gnupg2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn && \
    mkdir /var/run/sshd

RUN npm install -g bit-bin

# Install latest (stable) Bit version
#RUN curl https://bitsrc.jfrog.io/bitsrc/api/gpg/key/public |  apt-key add -
#RUN sh -c "echo 'deb http://bitsrc.jfrog.io/bitsrc/bit-deb all stable' >> /etc/apt/sources.list"
#RUN apt-get update
#RUN apt-get install bit -y
RUN groupadd --gid 2000 bit \
    && useradd --uid 2000 --gid bit --shell /bin/bash --create-home bit && \
    usermod -aG sudo bit && \
    ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers && \
    mkdir -p /home/bit/.ssh && \
    mkdir /opt/scope
WORKDIR /opt/scope
COPY init.sh /opt/
RUN chown bit /opt/scope && chmod +x /opt/init.sh
VOLUME ["/opt/scope"]
USER bit

RUN bit config set analytics_reporting false && \
    bit config set error_reporting false && \
    bit config set no_warnings true


EXPOSE 22
CMD  ["/opt/init.sh"]
