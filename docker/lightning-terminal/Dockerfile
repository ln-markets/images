FROM alpine AS git

ARG VERSION

ENV LIT_PKG_DIR="/go/src/github.com/lightninglabs/lightning-terminal"

RUN apk add --no-cache --update \
    git \
    gnupg

RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 26984CB69EB8C4A26196F7A4D7D916376026F177 && \
    git clone https://github.com/lightninglabs/lightning-terminal.git ${LIT_PKG_DIR} && \
    cd ${LIT_PKG_DIR} && \
    git checkout ${VERSION} && \
    git verify-tag ${VERSION}

FROM node:16.14.2-alpine as node

ARG PUBLIC_URL=""

ENV LIT_PKG_DIR="/go/src/github.com/lightninglabs/lightning-terminal"

COPY --from=git ${LIT_PKG_DIR} ${LIT_PKG_DIR}

RUN yarn config set registry "http://registry.npmjs.org" && \
    echo --network-timeout 1000000 >> ~/.yarnrc && \
    cd ${LIT_PKG_DIR}/app && \
    yarn install --frozen-lockfile && \
    yarn build

FROM golang:1.19-alpine AS go

ARG PUBLIC_URL=""

ENV LIT_PKG_DIR="/go/src/github.com/lightninglabs/lightning-terminal"

COPY --from=node ${LIT_PKG_DIR} ${LIT_PKG_DIR}

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    git \
    make

RUN cd ${LIT_PKG_DIR} &&  \
    make go-install PUBLIC_URL=$PUBLIC_URL

FROM alpine:3.16

ENV DATA_PATH=/home/.lit

COPY --from=go /go/bin/litd /bin/
COPY --from=go /go/bin/litcli /bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint-alpine.sh /docker/entrypoint.sh

EXPOSE 8443

ENTRYPOINT [ "/docker/entrypoint.sh", "litd" ]
