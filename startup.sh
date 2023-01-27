#!/bin/bash
echo "putass"
eval "$(ssh-agent -s)"
ssh-add /var/jenkins_home/.ssh/id_rsa
/usr/local/bin/jenkins.sh