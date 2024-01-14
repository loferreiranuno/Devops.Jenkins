FROM jenkins/jenkins as base
USER root

ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY
ARG SSH_KNOWN_HOSTS

# Crea la carpeta para las claves SSH
RUN mkdir -p /tmp/ssh_keys/

# Crea los archivos de claves SSH en la carpeta
RUN echo "$SSH_PRIVATE_KEY" > /tmp/ssh_keys/id_rsa
RUN echo "$SSH_PUBLIC_KEY" > /tmp/ssh_keys/id_rsa.pub
RUN echo "$SSH_KNOWN_HOSTS" > /tmp/ssh_keys/known_hosts

# Cambia los permisos de las claves SSH
RUN chmod -R 700 /tmp/ssh_keys/ 
RUN chmod 600 /tmp/ssh_keys/id_rsa

# Cambia el propietario de las claves SSH
RUN chown jenkins:jenkins /tmp/ssh_keys/ -R 

# Selecciona la imagen de Jenkins
FROM jenkins/jenkins

# Cambia al usuario root
USER root

# Copia las claves SSH desde la primera imagen
COPY --chown=jenkins:jenkins --from=base /tmp/ssh_keys /var/jenkins_home/.ssh

# RUN chown -R jenkins:jenkins /usr/share/java/jenkins/

# Instala paquetes necesarios
RUN apt-get update && apt-get install -y lsb-release git openssh-server nano

# Instala Docker
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Instala docker compose
RUN curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

RUN apt-get update && apt-get install -y docker-ce-cli docker-ce docker-compose-plugin

# Agrega jenkins al grupo de docker
RUN usermod -aG docker jenkins  

# Copia el archivo de inicio y cambia los permisos
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# Cambia al usuario jenkins
USER jenkins

# Instala los plugins de Jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent docker-plugin apache-httpcomponents-client-5-api:5.2.1-1.1" 