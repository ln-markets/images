FROM alpine:3.16

ARG TOR_VERSION=0.4.7.10-r0

RUN apk add --no-cache --update \
    tor=${TOR_VERSION} \
    bash \
    su-exec \
    shadow

RUN deluser tor && \
    addgroup --system --gid 1000 tor && \
    adduser tor -G tor --system --home /home --uid 1000

COPY entrypoint.sh /docker/entrypoint.sh

EXPOSE 9050 9051

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD [ "tor" ]
