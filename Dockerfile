FROM jenkins/jenkins:lts

USER root

COPY ./docker-entrypoint.sh /

RUN apt-get update && apt-get install -y lsb-release git openssh-server

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
   
RUN apt-get update && apt-get install -y docker-ce-cli docker-ce

RUN usermod -aG docker jenkins 

# Set permissions
RUN chown -R jenkins:jenkins /var/jenkins_home 
RUN mkdir -p /tmp/.ssh
RUN chown -R jenkins:jenkins /tmp/.ssh 

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["sh"]

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent yet-another-docker-plugin docker-plugin"