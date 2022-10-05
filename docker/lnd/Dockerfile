FROM golang:1.18.2-alpine as builder

ENV LND_VERSION=v0.15.1-beta
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

RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/lnd-source-${LND_VERSION}.tar.gz
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-${LND_VERSION}.txt
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-roasbeef-${LND_VERSION}.sig

RUN wget -O - https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/roasbeef.asc | gpg --import && \
    gpg --verify manifest-roasbeef-${LND_VERSION}.sig manifest-${LND_VERSION}.txt && \
    cat  manifest-${LND_VERSION}.txt | grep -q "$(shasum -a 256 lnd-source-${LND_VERSION}.tar.gz)"

RUN tar -xvzf lnd-source-${LND_VERSION}.tar.gz && \
    cd lnd-source \
    &&  make \
    &&  make install tags="autopilotrpc signrpc walletrpc chainrpc invoicesrpc neutrinorpc routerrpc watchtowerrpc monitoring peersrpc kvdb_postrgres kvdb_etcd"

FROM alpine:3.16

LABEL maintainer="victor@lnmarkets.com"

ENV LND_CONF_PATH=/conf/lnd.conf

COPY --from=builder /go/bin/lncli /usr/local/bin/
COPY --from=builder /go/bin/lnd /usr/local/bin/

RUN apk add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 lnd
RUN adduser lnd --system --uid 1000 --home /lnd -G lnd

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9735 9911 10009 8080

VOLUME ["/lnd/.lnd"]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lnd"]
