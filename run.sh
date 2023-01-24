#!/bin/sh
export DOCKER_PATH=$(which docker)
docker build -t jenkins-blueocean:0.0.1-1 --build-arg ssh_path="/var/jenkins_home/.ssh" --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" . || true 
docker-compose up --detach --remove-orphans --force-recreate 