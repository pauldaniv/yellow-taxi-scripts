FROM ghcr.io/pauldaniv/yellow-taxi-scripts/base:latest

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install screen curl git gnupg apt-transport-https ca-certificates lsb-release \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | \
  gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  &&  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null  \
  && apt-get -y update  \
  && apt-get -y install docker-ce docker-ce-cli containerd.io amazon-ecr-credential-helper  \
  &&  apt-get clean && rm -rf /var/lib/apt/lists/*


ADD ci.sh /usr/local/bin/ci
ADD config.json /home/root/.docker/config.json
RUN chmod +x /usr/local/bin/ci

USER root
WORKDIR /home/root

CMD ["/bin/bash"]
