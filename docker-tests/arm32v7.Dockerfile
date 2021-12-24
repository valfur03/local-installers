FROM arm32v7/debian:10-slim

RUN set -eux; \
	apt-get update; \
	apt-get install -y wget tar xz-utils libatomic1;

WORKDIR /usr/src

RUN set -eux; \
	useradd -m test;
USER test
