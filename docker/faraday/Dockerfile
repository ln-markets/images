FROM golang:1.19.3-alpine AS builder

ARG VERSION
ARG COMMIT

ENV FARADAY_PKG_DIR="/go/src/github.com/lightninglabs/faraday"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightninglabs/faraday.git ${FARADAY_PKG_DIR} && \
    cd ${FARADAY_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi


RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F4FC70F07310028424EFC20A8E4256593F177720 && \
    cd ${FARADAY_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git verify-tag ${VERSION} ; fi

RUN cd ${FARADAY_PKG_DIR} && make install

FROM lnmarkets/base-alpine:3.20

COPY --from=builder /go/bin/faraday /bin/
COPY --from=builder /go/bin/frcli /bin/

ENV DATA_PATH=/home/.faraday

EXPOSE 8465

ENTRYPOINT [ "/docker/entrypoint.sh", "faraday" ]
