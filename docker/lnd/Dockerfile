FROM golang:1.19-alpine AS builder

ARG LND_VERSION=v0.15.1-beta
ARG LND_BUILD_TAGS="autopilotrpc signrpc walletrpc chainrpc invoicesrpc neutrinorpc routerrpc watchtowerrpc monitoring peersrpc kvdb_postrgres kvdb_etcd"
ARG LND_COMMIT

ENV LND_PKG_DIR="/go/src/github.com/lightningnetwork/lnd"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on
    
RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightningnetwork/lnd.git ${LND_PKG_DIR} && \
    cd ${LND_PKG_DIR}  && \
    if [[ -z "$LND_COMMIT" ]] ; then git checkout ${LND_VERSION} ; else git checkout ${LND_COMMIT} ; fi

RUN wget -O - https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/roasbeef.asc | gpg --import && \
    cd ${LND_PKG_DIR}  && \
    if [[ -z "$LND_COMMIT" ]] ; then git verify-tag ${LND_VERSION} ; fi

RUN cd ${LND_PKG_DIR} && make install tags="${LND_BUILD_TAGS}"

FROM alpine:3.16

ENV LND_CONF_PATH=/lnd/.lnd/lnd.conf

COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/

RUN apk add --no-cache --update \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 lnd
RUN adduser lnd --system --uid 1000 --home /lnd -G lnd

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9735 9911 10009 8080

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lnd"]
