FROM alpine:3.16

ARG TOR_VERSION=0.4.7.10-r0

RUN apk add --no-cache --update \
    tor=${TOR_VERSION} \
    bash \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 tor && \
    adduser toruser -G tor --system --home /home --uid 1000

COPY entrypoint.sh /entrypoint.sh

EXPOSE 9050 9051

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "tor" ]
