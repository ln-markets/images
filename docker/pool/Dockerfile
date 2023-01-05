FROM golang:1.19.3-alpine AS builder

ARG VERSION
ARG COMMIT
ARG SKIP_VERIFY_TAG

ENV POOL_PKG_DIR="/go/src/github.com/lightninglabs/pool"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightninglabs/pool.git ${POOL_PKG_DIR} && \
    cd ${POOL_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi


RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F4FC70F07310028424EFC20A8E4256593F177720 && \
    cd ${POOL_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] && [[ -ne "$SKIP_VERIFY_TAG"]] ; then git verify-tag ${VERSION} ; fi

RUN cd ${POOL_PKG_DIR} && make install

FROM lnmarkets/base-alpine:3.16

ENV DATA_PATH=/home/.pool

COPY --from=builder /go/bin/pool /bin/
COPY --from=builder /go/bin/poold /bin/

EXPOSE 12010 8281

ENTRYPOINT [ "/docker/entrypoint.sh", "poold" ]
