FROM arm32v7/alpine

RUN set -eux; \
	apk add --update-cache curl

RUN set -eux; \
	adduser -D test;

USER test
