FROM golang:1.19-alpine AS builder

ARG TARO_VERSION=v0.1.0-alpha
ARG TARO_COMMIT

ENV TARO_PKG_DIR="/go/src/github.com/lightningnetwork/taro"

RUN apk add --no-cache --update \
    make \
    git

RUN git clone https://github.com/lightninglabs/taro.git ${TARO_PKG_DIR} && \
    cd ${TARO_PKG_DIR}  && \
    if [[ -z "$TARO_COMMIT" ]] ; then git checkout ${TARO_VERSION} ; else git checkout ${TARO_COMMIT} ; fi

RUN cd ${TARO_PKG_DIR} && make install

FROM alpine:3.16

COPY --from=builder /go/bin/tarod /bin/tarod
COPY --from=builder /go/bin/tarocli bin/tarocli

RUN apk add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 taro
RUN adduser taro --system --uid 1000 --home /taro -G taro

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 10029 8089

VOLUME ["/taro/.taro"]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["tarod"]
