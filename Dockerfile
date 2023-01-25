FROM jenkins/jenkins

USER root
 
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

RUN apt-get update && apt-get install -y lsb-release git openssh-server 

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli docker-ce

RUN usermod -aG docker jenkins

USER jenkins

# Instale o plugin do GitHub
RUN /usr/local/bin/install-plugins.sh github

# Instale o plugin "Docker in Docker"
RUN /usr/local/bin/install-plugins.sh docker-workflow

RUN ssh-add /var/jenkins_home/.ssh/id_rsa