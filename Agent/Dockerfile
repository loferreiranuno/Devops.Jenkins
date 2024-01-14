FROM jenkins/agent:latest-stretch-jdk11

ARG user=jenkins

ENV DOCKERVERSION=20.10.23
ENV DOCKER_COMPOSE_VERSION=2.15.1

LABEL Description="This image is derived from jenkins/agent openjdk11. \
      It includes docker static binary"

USER root
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" 
RUN apt-get update && apt-get install -y docker-ce-cli docker-ce 

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && chown jenkins:jenkins /usr/local/bin/docker-compose
    
# Agrega jenkins al grupo de docker
RUN usermod -aG docker ${user}  

# Set the working directory
WORKDIR /root

# Run a shell command to add the alias to the profile file
RUN echo "alias docker-compose='docker compose'" >> ~/.bashrc

WORKDIR /home/${user}

USER ${user}