#!/bin/bash
eval "$(ssh-agent -s)"
ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-add ~/.ssh/id_rsa
/usr/local/bin/jenkins.sh