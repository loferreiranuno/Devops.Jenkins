FROM jenkins/jenkins as base
USER root

ENV SSH_PRIVATE_KEY=""
ENV SSH_PUBLIC_KEY=""
ENV SSH_KNOWN_HOSTS=""

# Crea la carpeta para las claves SSH
RUN mkdir -p /tmp/ssh_keys/

# Crea los archivos de claves SSH en la carpeta
RUN echo "$SSH_PRIVATE_KEY" > /tmp/ssh_keys/id_rsa
RUN echo "$SSH_PUBLIC_KEY" > /tmp/ssh_keys/id_rsa.pub
RUN echo "$SSH_KNOWN_HOSTS" > /tmp/ssh_keys/known_hosts

# Cambia los permisos de las claves SSH
RUN chmod 700 /tmp/ssh_keys/
RUN chmod 600 /tmp/ssh_keys/*

# Cambia el propietario de las claves SSH
RUN chown $USER /tmp/ssh_keys/ -R 

# Selecciona la imagen de Jenkins
FROM jenkins/jenkins

# Cambia al usuario root
USER root

# Copia las claves SSH desde la primera imagen
COPY --chown=$USER --from=base /tmp/ssh_keys $JENKINS_HOME/.ssh

# Instala paquetes necesarios
RUN apt-get update && apt-get install -y lsb-release git openssh-server nano

# Instala Docker
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli docker-ce

# Agrega jenkins al grupo de docker
RUN usermod -aG docker jenkins  

# Copia el archivo de inicio y cambia los permisos
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# Cambia al usuario jenkins
USER jenkins

# Instala los plugins de Jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent docker-plugin" 