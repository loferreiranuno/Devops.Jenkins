FROM jenkins/agent:latest-stretch-jdk11

ARG user=jenkins

ENV DOCKERVERSION=19.03.12

LABEL Description="This image is derived from jenkins/agent openjdk11. \
      It includes docker static binary"

USER root

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

WORKDIR /home/${user}

USER ${user}
