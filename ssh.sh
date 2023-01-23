#!/bin/sh

mkdir -p /var/jenkins_home/.ssh
ssh-keyscan github.com >> /var/jenkins_home/.ssh/known_hosts 
cat ~/.ssh/id_rsa > /var/jenkins_home/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub > /var/jenkins_home/.ssh/id_rsa.pub