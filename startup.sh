#!/bin/bash
eval "$(ssh-agent -s)"
ssh-keyscan github.com >> /var/jenkins_home/.ssh/known_hosts
ssh-add /var/jenkins_home/.ssh/id_rsa
/usr/local/bin/jenkins.sh