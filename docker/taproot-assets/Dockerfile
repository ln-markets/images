FROM golang:1.22.6-alpine AS builder

ARG VERSION
ARG COMMIT

ENV GODEBUG netdns=cgo
ENV PKG_DIR="/go/src/github.com/lightninglabs/taproot-assets"

RUN apk add --no-cache --update \
    make \
    git \
    gcc

RUN git clone https://github.com/lightninglabs/taproot-assets.git ${PKG_DIR} && \
    cd ${PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN cd ${PKG_DIR} && make release-install

FROM lnmarkets/base-alpine:3.20

ENV DATA_PATH=/home/.tapd

COPY --from=builder /go/bin/tapd /bin/tapd
COPY --from=builder /go/bin/tapcli bin/tapcli

EXPOSE 10029 8089

ENTRYPOINT [ "/docker/entrypoint.sh", "tapd" ]
