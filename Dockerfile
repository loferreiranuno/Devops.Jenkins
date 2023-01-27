FROM jenkins/jenkins as base
USER root

# RUN mkdir -p /var/jenkins_home/.ssh
# RUN chown jenkins:jenkins /var/jenkins_home/.ssh -R
RUN mkdir -p /tmp/ssh_keys/
RUN ${SSH_PRIVATE_KEY} > /tmp/ssh_keys/id_rsa
RUN ${SSH_PUBLIC_KEY} > /tmp/ssh_keys/id_rsa.pub
RUN ${SSH_PUBLIC_KEY} > /tmp/ssh_keys/known_hosts
RUN chown jenkins:jenkins /tmp/ssh_keys/id_rsa
RUN chown jenkins:jenkins /tmp/ssh_keys/known_hosts

FROM jenkins/jenkins

USER root

COPY --chown=jenkins:jenkins --from=base /tmp/ssh_keys $JENKINS_HOME/.ssh

RUN chown jenkins:jenkins $JENKINS_HOME/.ssh/id_rsa

RUN apt-get update && apt-get install -y lsb-release git openssh-server nano

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli docker-ce

RUN usermod -aG docker jenkins  

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

USER jenkins


# Instale o plugin do GitHub 
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent docker-plugin" 