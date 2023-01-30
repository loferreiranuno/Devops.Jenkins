#!/bin/bash
eval "$(ssh-agent -s)"
sudo chown -R jenkins:jenkins /var/jenkins_home/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-add ~/.ssh/id_rsa
/usr/local/bin/jenkins.sh