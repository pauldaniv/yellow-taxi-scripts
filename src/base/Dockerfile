FROM debian

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>

RUN apt-get -y update \
     && apt-get -y upgrade \
     && apt-get install -y wget curl git

WORKDIR /home/root

CMD ["/bin/sh"]
