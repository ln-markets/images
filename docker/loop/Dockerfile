FROM golang:1.19-alpine AS builder

ARG LOOP_VERSION=v0.20.1-beta
ARG LOOP_COMMIT

ENV LOOP_PKG_DIR="/go/src/github.com/lightninglabs/loop"

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    gnupg \
    make \
    git

RUN git clone https://github.com/lightninglabs/loop.git ${LOOP_PKG_DIR} && \
    cd ${LOOP_PKG_DIR}  && \
    if [[ -z "$LOOP_COMMIT" ]] ; then git checkout ${LOOP_VERSION} ; else git checkout ${LOOP_COMMIT} ; fi

# Key is expired
# RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys DE23E73BFA8A0AD5587D2FCDE80D2F3F311FD87E && \
#     cd ${LOOP_PKG_DIR}  && \
#     if [[ -z "$LOOP_COMMIT" ]] ; then git verify-tag ${LOOP_VERSION} ; fi

RUN cd ${LOOP_PKG_DIR} && make install

FROM alpine:3.16

ENV LOOP_PATH=/home/.loop

COPY --from=builder /go/bin/loop /bin/
COPY --from=builder /go/bin/loopd /bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 ${USER} && \
    adduser ${USER} -G ${USER} --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./docker/loop/entrypoint.sh /docker/entrypoint.sh

EXPOSE 8081 11010

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["loopd"]
