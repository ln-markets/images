ARG VERSION
ARG PUBLIC_URL=""

FROM alpine AS git

RUN apk add --no-cache --update \
    git \
    gnupg

RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 187F6ADD93AE3B0CF335AA6AB984570980684DCC && \
    git clone https://github.com/lightninglabs/lightning-terminal.git /go/src/github.com/lightninglabs/lightning-terminal && \
    cd /go/src/github.com/lightninglabs/lightning-terminal && \
    git checkout ${VERSION}

FROM node:20.9.0-alpine as node

COPY --from=git /go/src/github.com/lightninglabs/lightning-terminal /go/src/github.com/lightninglabs/lightning-terminal

RUN yarn config set registry "http://registry.npmjs.org" && \
    echo --network-timeout 1000000 >> ~/.yarnrc && \
    cd /go/src/github.com/lightninglabs/lightning-terminal/app && \
    yarn install --frozen-lockfile && \
    yarn build

FROM golang:1.22.4-alpine AS go

ENV GODEBUG netdns=cgo

COPY --from=node /go/src/github.com/lightninglabs/lightning-terminal /go/src/github.com/lightninglabs/lightning-terminal

RUN apk add --no-cache --update \
    alpine-sdk \
    git \
    make

RUN cd /go/src/github.com/lightninglabs/lightning-terminal && make go-install PUBLIC_URL=$PUBLIC_URL

FROM lnmarkets/base-alpine:3.20

COPY --from=go /go/bin/litd /bin/

ENV DATA_PATH=/home/.lit

EXPOSE 8443

ENTRYPOINT [ "/docker/entrypoint.sh", "litd" ]
