#!/bin/bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jenkins/id_rsa
/usr/local/bin/jenkins.sh