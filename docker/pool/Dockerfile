FROM golang:1.19-alpine AS builder

ARG POOL_VERSION=v0.5.8-alpha
ARG POOL_COMMIT

ENV POOL_PKG_DIR="/go/src/github.com/lightninglabs/pool"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightninglabs/pool.git ${POOL_PKG_DIR} && \
    cd ${POOL_PKG_DIR}  && \
    if [[ -z "$POOL_COMMIT" ]] ; then git checkout ${POOL_VERSION} ; else git checkout ${POOL_COMMIT} ; fi


RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F4FC70F07310028424EFC20A8E4256593F177720 && \
    cd ${POOL_PKG_DIR}  && \
    if [[ -z "$POOL_COMMIT" ]] ; then git verify-tag ${POOL_VERSION} ; fi

RUN cd ${POOL_PKG_DIR} && make install

FROM alpine:3.16

ENV POOL_PATH=/home/.pool

COPY --from=builder /go/bin/pool /bin/
COPY --from=builder /go/bin/poold /bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./docker/pool/entrypoint.sh /docker/entrypoint.sh

EXPOSE 12010 8281

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["poold"]
