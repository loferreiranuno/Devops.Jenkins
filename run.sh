#!/bin/sh
DOCKER_PATH=$(which docker)
docker-compose up --detach --remove-orphans --force-recreate
