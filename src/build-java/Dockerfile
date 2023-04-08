FROM debian

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install screen awscli apt-transport-https ca-certificates curl gnupg lsb-release \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    &&  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null  \
    && apt-get -y update  \
    && apt-get -y install docker-ce docker-ce-cli containerd.io amazon-ecr-credential-helper  \
    &&  apt-get clean && rm -rf /var/lib/apt/lists/*


WORKDIR /home/root
ADD ci.sh /usr/bin/ci
ADD config.json /home/root/.docker/config.json
RUN chmod +x /usr/bin/ci

CMD ["/bin/bash"]
