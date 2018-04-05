FROM jenkins

LABEL maintainer="wale soyinka <wsoyinka@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

USER root

ARG DOCKER_GID=497


RUN groupadd -g ${DOCKER_GID:-497} docker


ARG DOCKER_ENGINE=18.03.0-ce
ARG DOCKER_VERSION=18.03.0~ce-0~debian
ARG DOCKER_COMPOSE=1.20.1


RUN apt-get update -u && \
	apt-get -y install apt-transport-https ca-certificates curl python-dev python-setuptools gnupg2 software-properties-common && \
	easy_install pip

RUN  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \ 
	add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable" && \
	apt-get update && \
	apt-get -y install docker-ce=${DOCKER_VERSION:-18.03.0~ce-0~debian} && \
	usermod -aG  docker jenkins && \
	usermod -aG users jenkins && \
	usermod -aG root jenkins 

RUN  pip install docker-compose==${DOCKER_COMPOSE:-1.20.1} && \
	pip install ansible boto boto3

USER jenkins

COPY plugins.txt  /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh  < /usr/share/jenkins/ref/plugins.txt
