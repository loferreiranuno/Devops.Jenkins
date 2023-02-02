FROM jenkins/agent

ARG user=jenkins

LABEL Description="This image is derived from jenkins/agent openjdk11. \
      It includes docker static binary"

USER root
 
# Instala paquetes necesarios
RUN apt-get update && apt-get install -y lsb-release git openssh-server nano

# Instala Docker
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Instala docker compose
RUN curl -L https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

RUN chown $user:docker /var/run/docker.sock

WORKDIR /home/${user}

USER ${user}
