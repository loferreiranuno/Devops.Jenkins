FROM jenkins/jenkins:lts

ARG ssh_prv_key
ARG ssh_pub_key

USER root

RUN apt-get update && apt-get install -y lsb-release git openssh-server
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli docker-ce sudo nano
RUN usermod -aG docker jenkins

# Authorize SSH Host
RUN sudo mkdir -p /var/jenkins_home/.ssh && \
    chmod 0700 /var/jenkins_home/.ssh && \
    ssh-keyscan github.com > /var/jenkins_home/.ssh/known_hosts && \
    chown -R jenkins:jenkins /var/jenkins_home
 
# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /var/jenkins_home/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /var/jenkins_home/.ssh/id_rsa.pub && \
    chmod 600 /var/jenkins_home/.ssh/id_rsa && \
    chmod 600 /var/jenkins_home/.ssh/id_rsa.pub 

# Set permissions
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent yet-another-docker-plugin docker-plugin"