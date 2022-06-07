
# Para tener un acceso seguro via HTTPS se utilizara un método de multiestados
# Fuente: https://vsupalov.com/build-docker-image-clone-private-repo-ssh-key/
# Este es el primer estado, no persistirá en la imagen final de docker
FROM amazoncorretto:11 as intermediate

# instalamos git
RUN apk update
RUN apk install -y git

# agregamos las credenciales en la construcción
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa

# agregamos los dominio para que sean aceptados
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone git@github.com:a171117/dockerygit.git

FROM amazoncorretto:11
# copiamos el repositorio de la imagen previa
COPY --from=intermediate /dockerygit /srv/dockerygit
# ... usamos el repositorio
WORKDIR /srv/dockerygit/src/main/java/com/fierabras/dockerjavaconsola/
RUN ["javac","DockerJavaConsola.java"]
ENTRYPOINT ["java","DockerJavaConsola"]
