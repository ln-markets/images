FROM golang:1.22.4-alpine AS builder

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

RUN wget -O - https://github.com/alexbosworth.gpg | gpg --import && \
    cd ${LOOP_PKG_DIR}  && \
    if [[ -z "$COMMIT" ]] && [[ -ne "$SKIP_VERIFY_TAG"]] ; then \
        git verify-tag "${VERSION}" || { git verify-tag --raw "${VERSION}" 2>&1 | grep 'EXPKEYSIG\|VALIDSIG' && echo "Accepting expired key!"; } \
    ;fi

RUN cd ${LOOP_PKG_DIR} && make install

FROM lnmarkets/base-alpine:3.18

ENV DATA_PATH=/home/.loop

COPY --from=builder /go/bin/loop /bin/
COPY --from=builder /go/bin/loopd /bin/

EXPOSE 8081 11010

ENTRYPOINT [ "/docker/entrypoint.sh", "loopd" ]
