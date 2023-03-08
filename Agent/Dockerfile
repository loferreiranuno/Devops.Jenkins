FROM jenkins/agent:latest-stretch-jdk11

ARG user=jenkins

ENV DOCKERVERSION=20.10.23
ENV DOCKER_COMPOSE_VERSION=2.16.0

LABEL Description="This image is derived from jenkins/agent openjdk11. \
      It includes docker static binary"

USER root

# Install Docker and Docker Compose
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli docker-ce

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN curl -fsSLO "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && chown ${user} /usr/local/bin/docker-compose

# Print the version of Docker Compose
RUN docker-compose version

# Add Jenkins user to the docker group
RUN usermod -aG docker ${user}   

# Set the working directory
WORKDIR /root

# Run a shell command to add the alias to the profile file
RUN echo "alias docker-compose='docker compose'" >> ~/.bashrc

WORKDIR /home/${user}

USER ${user}

ENV PATH="/usr/local/bin:${PATH}"
