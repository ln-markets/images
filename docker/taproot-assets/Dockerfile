FROM golang:1.19.9-alpine AS builder

ARG VERSION
ARG COMMIT

ENV GODEBUG netdns=cgo
ENV GO111MODULE on
ENV TAPROOT_ASSETS_PKG_DIR="/go/src/github.com/lightninglabs/taproot-assets"

RUN apk add --no-cache --update \
    make \
    git

RUN git clone https://github.com/lightninglabs/taproot-assets.git ${TAPROOT_ASSETS_PKG_DIR} && \
    cd ${TAPROOT_ASSETS_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN cd ${TAPROOT_ASSETS_PKG_DIR} && make install

FROM lnmarkets/base-alpine:3.18

ENV DATA_PATH=/home/.tapd

COPY --from=builder /go/bin/tapd /bin/tapd
COPY --from=builder /go/bin/tapcli bin/tapcli

EXPOSE 10029 8089

ENTRYPOINT [ "/docker/entrypoint.sh", "tapd" ]
