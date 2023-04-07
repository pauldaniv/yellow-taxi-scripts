FROM ghcr.io/pauldaniv/yellow-taxi-scripts/base

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install screen awscli apt-transport-https ca-certificates curl gnupg lsb-release

WORKDIR /home/root
ADD . /usr/bin/env

CMD ["/bin/sh"]
