FROM ghcr.io/helmfile/helmfile:latest

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

RUN apk add --update py3-pip \
  && pip3 install awscli==1.27.7 --upgrade --user

WORKDIR /home/root

CMD ["/bin/bash"]
