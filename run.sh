#!/bin/sh
export DOCKER_PATH=$(which docker)
docker build -t jenkins-blueocean:0.0.1-1 --build-arg SSH_PATH=/var/jenkins_home/.ssh/ --build-arg SSH_KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" --build-arg SSH_PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" . || true 
docker-compose up --detach --remove-orphans --force-recreate 