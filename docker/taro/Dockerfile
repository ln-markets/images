FROM golang:1.19.3-alpine AS builder

ARG VERSION
ARG COMMIT

ENV GODEBUG netdns=cgo
ENV GO111MODULE on
ENV TARO_PKG_DIR="/go/src/github.com/lightningnetwork/taro"

RUN apk add --no-cache --update \
    make \
    git

RUN git clone https://github.com/lightninglabs/taro.git ${TARO_PKG_DIR} && \
    cd ${TARO_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] || [ "$COMMIT" = "null" ] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN cd ${TARO_PKG_DIR} && make install

FROM lnmarkets/base-alpine:3.16

ENV DATA_PATH=/home/.taro

COPY --from=builder /go/bin/tarod /bin/tarod
COPY --from=builder /go/bin/tarocli bin/tarocli

EXPOSE 10029 8089

ENTRYPOINT [ "/docker/entrypoint.sh", "tarod" ]
