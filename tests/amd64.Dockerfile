FROM amd64/alpine

RUN set -eux; \
	apk add --update-cache curl

RUN set -eux; \
	adduser -D test;

USER test
