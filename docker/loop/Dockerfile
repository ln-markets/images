FROM golang:1.19.3-alpine AS builder

ARG VERSION
ARG COMMIT
ARG SKIP_VERIFY_TAG

ENV LOOP_PKG_DIR="/go/src/github.com/lightninglabs/loop"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightninglabs/loop.git ${LOOP_PKG_DIR} && \
    cd ${LOOP_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys DE23E73BFA8A0AD5587D2FCDE80D2F3F311FD87E && \
    cd ${LOOP_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] && [[ -ne "$SKIP_VERIFY_TAG"]] ; then git verify-tag ${VERSION} ; fi

RUN cd ${LOOP_PKG_DIR} && make install

FROM lnmarkets/base-alpine:3.16

ENV DATA_PATH=/home/.loop

COPY --from=builder /go/bin/loop /bin/
COPY --from=builder /go/bin/loopd /bin/

EXPOSE 8081 11010

ENTRYPOINT [ "/docker/entrypoint.sh", "loopd" ]
