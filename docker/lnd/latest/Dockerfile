FROM golang:1.18.2-alpine as lnd

ENV LND_VERSION=latest
ENV OS linux
ENV ARCH amd64
ENV GODEBUG netdns=cgo

RUN apk add --no-cache --update \
    alpine-sdk \
    gnupg \
    make \
    gcc \
    perl-utils

WORKDIR /opt

RUN git clone https://github.com/lightningnetwork/lnd.git && \
    cd lnd  && \
    make && \
    make install tags="autopilotrpc signrpc walletrpc chainrpc invoicesrpc neutrinorpc routerrpc watchtowerrpc monitoring peersrpc kvdb_postrgres kvdb_etcd"

FROM alpine:3.16

LABEL maintainer="victor@lnmarkets.com"

ENV LND_CONF_PATH=/conf/lnd.conf

COPY --from=lnd /go/bin/lncli /usr/local/bin/
COPY --from=lnd /go/bin/lnd /usr/local/bin/

RUN apk add \
    su-exec \
    shadow

RUN addgroup --system --gid 10000 lnd
RUN adduser lnd --system --uid 10000 --home /lnd -G lnd

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9735 9911 10009 8080

VOLUME ["/lnd/.lnd"]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lnd"]
