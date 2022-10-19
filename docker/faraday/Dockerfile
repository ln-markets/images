FROM golang:1.19-alpine AS builder

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

FROM alpine:3.16

ENV DATA_PATH=/home/.faraday

COPY --from=builder /go/bin/faraday /bin/
COPY --from=builder /go/bin/frcli /bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint-alpine.sh /docker/entrypoint.sh

EXPOSE 8465

ENTRYPOINT [ "/docker/entrypoint.sh", "faraday" ]
