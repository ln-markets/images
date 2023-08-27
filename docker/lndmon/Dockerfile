FROM golang:1.19.3-alpine AS builder

ARG VERSION
ARG COMMIT

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

ENV LNDMON_PKG_DIR="/go/src/github.com/lightninglabs/lndmon/"

RUN apk add --no-cache --update \
    git \
    make \
    bash

RUN git clone https://github.com/lightninglabs/lndmon.git ${LNDMON_PKG_DIR} && \
    cd ${LNDMON_PKG_DIR} && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN cd ${LNDMON_PKG_DIR}/cmd/lndmon && go build

FROM lnmarkets/base-alpine:3.18

COPY --from=builder /go/src/github.com/lightninglabs/lndmon/cmd/lndmon /bin/

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint-alpine.sh /docker/entrypoint.sh

ENTRYPOINT [ "/docker/entrypoint.sh", "lndmon" ]
