FROM jenkins/jenkins:lts

ARG ssh_prv_key
ARG ssh_pub_key
ARG ssh_path

USER root

RUN apt-get update && apt-get install -y lsb-release git openssh-server
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli docker-ce
RUN usermod -aG docker jenkins

# Authorize SSH Host
RUN mkdir -p "$ssh_path" && \
    chmod 777 "$ssh_path" && \
    ssh-keyscan github.com > "$ssh_path"/known_hosts
 
# Add the keys and set permissions
RUN echo "$ssh_prv_key" > "$ssh_path"/id_rsa && \
    echo "$ssh_pub_key" > "$ssh_path"/id_rsa.pub && \
    chmod 777 "$ssh_path"/id_rsa && \
    chmod 777 "$ssh_path"/id_rsa.pub 

# Set permissions 
RUN chown -R jenkins:jenkins "$ssh_path"

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent yet-another-docker-plugin docker-plugin"