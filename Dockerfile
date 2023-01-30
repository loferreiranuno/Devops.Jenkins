# Selecciona la imagen de Jenkins
FROM jenkins/jenkins

# Cambia al usuario root
USER root

ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY
ARG SSH_KNOWN_HOSTS
ARG SSH_PATH

# Crea la carpeta para las claves SSH
RUN mkdir -p ${SSH_PATH} 

# Crea los archivos de claves SSH en la carpeta
RUN echo "${SSH_PRIVATE_KEY}" > ${SSH_PATH}/id_rsa 
RUN echo "${SSH_PUBLIC_KEY}" > ${SSH_PATH}/id_rsa.pub 
RUN echo "${SSH_KNOWN_HOSTS}" > ${SSH_PATH}/known_hosts 

# Cambia los permisos de las claves SSH
RUN chmod 700 ${SSH_PATH}
RUN chmod 600 ${SSH_PATH}/*

# Cambia el propietario de las claves SSH
RUN chown jenkins:jenkins ${SSH_PATH} -R 

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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow ssh-agent docker-plugin" --skip-failed-plugins