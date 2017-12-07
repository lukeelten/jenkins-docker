FROM jenkins/jenkins:lts-alpine
LABEL maintainer="Tobias Derksen <tobias.derksen@student.fontys.nl>"

ARG DOCKER_GID=999

USER root

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && echo "@edge-com http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --no-cache add curl git busybox@edge docker@edge-com shadow sudo maven
RUN curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN groupmod -g $DOCKER_GID docker && gpasswd -a jenkins docker
# RUN sed -i.bak '2i sudo chgrp docker /var/run/docker.sock' /usr/local/bin/jenkins.sh

USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

VOLUME /var/jenkins_home
