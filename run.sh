#!/bin/sh
export DOCKER_PATH=$(which docker)
docker build -t jenkins-blueocean:0.0.1-1 . || true 
docker-compose up --detach --remove-orphans --force-recreate 