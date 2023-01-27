FROM jenkins/jenkins

USER root
 
COPY startup.sh /usr/local/bin/
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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent docker-plugin" 