#!/bin/sh
set -e

cp -R /tmp/.ssh /var/jenkins_home
chmod 700 /var/jenkins_home/.ssh
chmod 644 /var/jenkins_home/.ssh/id_rsa.pub
chmod 600 /var/jenkins_home/.ssh/id_rsa

exec "$@"