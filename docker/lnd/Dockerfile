FROM golang:1.19-alpine AS builder

ARG VERSION
ARG LND_BUILD_TAGS="autopilotrpc signrpc walletrpc chainrpc invoicesrpc neutrinorpc routerrpc watchtowerrpc monitoring peersrpc kvdb_postrgres kvdb_etcd"
ARG COMMIT

ENV LND_PKG_DIR="/go/src/github.com/lightningnetwork/lnd"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightningnetwork/lnd.git ${LND_PKG_DIR} && \
    cd ${LND_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN wget -O - https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/roasbeef.asc | gpg --import && \
    cd ${LND_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git verify-tag ${VERSION} ; fi

RUN cd ${LND_PKG_DIR} && make install tags="${LND_BUILD_TAGS}"

FROM alpine:3.16

ENV LND_CONF_PATH=/home/.lnd/lnd.conf
ENV DATA_PATH=/home/.lnd

COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/

RUN apk add --no-cache --update \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./docker/lnd/entrypoint.sh /docker/entrypoint.sh

EXPOSE 9735 9911 10009 8080

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["lnd"]
