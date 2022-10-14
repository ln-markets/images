FROM alpine:3.16

ARG VERSION

RUN apk add --no-cache --update \
    tor=${VERSION} \
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
