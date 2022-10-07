FROM golang:1.19-alpine AS builder

ARG LNDMON_VERSION=v0.2.1
ARG LNDMON_COMMIT

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

ENV LNDMON_PKG_DIR="/go/src/github.com/lightninglabs/lndmon/"

RUN apk add --no-cache --update \
    git \
    make \
    bash

RUN git clone https://github.com/lightninglabs/lndmon.git ${LNDMON_PKG_DIR} && \
    cd ${LNDMON_PKG_DIR} && \
    if [[ -z "$LNDMON_COMMIT" ]] ; then git checkout ${LNDMON_VERSION} ; else git checkout ${LNDMON_COMMIT} ; fi

RUN cd ${LNDMON_PKG_DIR}/cmd/lndmon && go build

FROM alpine:3.16

COPY --from=builder /go/src/github.com/lightninglabs/lndmon/cmd/lndmon /bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system lndmon
RUN adduser lndmon --system --home /lndmon -G lndmon

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lndmon"]
