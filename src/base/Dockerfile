FROM debian

MAINTAINER Pavlo Daniv <pauldaniv@gmail.com>
LABEL org.opencontainers.image.source=https://github.com/pauldaniv/yellow-taxi-scripts

RUN echo "Update and Install dependencies" \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get install -y curl git zip screen

RUN echo 'Install AWSCLIv2' \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && aws --version

WORKDIR /home/root

CMD ["/bin/bash"]
