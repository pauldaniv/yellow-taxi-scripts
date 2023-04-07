FROM debian

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

RUN apt-get -y update \
     && apt-get -y upgrade \
     && apt-get install -y wget curl git

WORKDIR /home/root

CMD ["/bin/sh"]
