FROM ubuntu:latest

LABEL maintainer="Schlegel, Dr. Fabian" \
    description="TwonkyServer"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy upgrade --fix-missing --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qy --fix-missing --no-install-recommends \
    bash \
    imagemagick \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/twonky

RUN wget http://www.twonkyforum.com/downloads/8.5/twonky-x86-64-glibc-2.22-8.5.zip \
    && unzip twonky-x86-64-glibc-2.22-8.5.zip \
    && rm -f twonky-x86-64-glibc-2.22-8.5.zip

VOLUME /config /data

EXPOSE 1030/udp 1900/udp 9000/tcp 5353/udp 443/tcp

COPY ./entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
