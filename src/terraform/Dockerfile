FROM ghcr.io/pauldaniv/yellow-taxi-scripts/base:latest

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install wget curl git screen apt-transport-https ca-certificates gnupg lsb-release \
    && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
        tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && gpg --no-default-keyring \
       --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
       --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
       https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
       tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update \
    && apt-get install terraform

WORKDIR /home/root

CMD ["/bin/bash"]
