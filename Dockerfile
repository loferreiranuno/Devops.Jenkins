FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install -y lsb-release git openssh-server docker-ce-cli docker-ce

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
 
RUN usermod -aG docker jenkins

# Set permissions
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins

# Use as chaves SSH fornecidas como variáveis de ambiente
RUN mkdir ~/.ssh
RUN echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
RUN echo "$SSH_PUBLIC_KEY" > ~/.ssh/id_rsa.pub

# Instale o plugin do GitHub
RUN /usr/local/bin/install-plugins.sh github

# Instale o plugin "Docker in Docker"
RUN /usr/local/bin/install-plugins.sh docker-workflow