#!/bin/sh
export DOCKER_PATH=$(which docker)
docker build -t jenkins-blueocean:0.0.1-1  --build-arg SSH_PATH=/var/jenkins_home/.ssh . || true 
docker-compose up --detach --remove-orphans --force-recreate 