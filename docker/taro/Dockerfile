FROM golang:1.19-alpine AS builder

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
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN cd ${TARO_PKG_DIR} && make install

FROM alpine:3.16

COPY --from=builder /go/bin/tarod /bin/tarod
COPY --from=builder /go/bin/tarocli bin/tarocli

RUN apk add --no-cache --update \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./docker/pool/entrypoint.sh /docker/entrypoint.sh

EXPOSE 10029 8089

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["tarod"]
