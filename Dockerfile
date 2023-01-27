FROM jenkins/jenkins

USER root

# Create the .ssh folder and set ownership to jenkins
RUN mkdir -p /var/jenkins_home/.ssh
RUN chown jenkins:jenkins /var/jenkins_home/.ssh -R

# Add the private and public key to the .ssh folder
RUN echo $SSH_PRIVATE_KEY > /var/jenkins_home/.ssh/id_rsa
RUN echo $SSH_PUBLIC_KEY > /var/jenkins_home/.ssh/id_rsa.pub

# Set the correct permissions on the .ssh folder and its contents
RUN chmod 700 /var/jenkins_home/.ssh
RUN chmod 600 /var/jenkins_home/.ssh/*

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