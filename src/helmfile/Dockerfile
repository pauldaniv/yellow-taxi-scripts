FROM ghcr.io/helmfile/helmfile:latest

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install screen awscli

WORKDIR /home/root

CMD ["/bin/bash"]
