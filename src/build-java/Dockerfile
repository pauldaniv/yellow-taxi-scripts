FROM ghcr.io/pauldaniv/yellow-taxi-scripts/base

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install screen awscli apt-transport-https ca-certificates curl gnupg lsb-release

WORKDIR /home/root
ADD ci.sh /usr/bin/env/ci
RUN chmod +x /usr/bin/env/ci

CMD ["/bin/sh"]
