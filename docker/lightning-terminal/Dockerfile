FROM golang:1.19-alpine AS builder

ARG LIGHTNING_TERMINAL_VERSION=v0.8.0-alpha

ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk add --no-cache --update \
    alpine-sdk \
    bash \
    ca-certificates \
    gnupg \
    perl-utils \
    git \
    make \
    nodejs \
    yarn

RUN yarn config set registry "http://registry.npmjs.org" && \
    echo --network-timeout 1000000 >> ~/.yarnrc

RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 26984CB69EB8C4A26196F7A4D7D916376026F177 && \
    git clone https://github.com/lightninglabs/lightning-terminal.git /go/src/github.com/lightninglabs/lightning-terminal && \
    cd /go/src/github.com/lightninglabs/lightning-terminal && \
    git checkout ${LIGHTNING_TERMINAL_VERSION} && \
    git verify-tag ${LIGHTNING_TERMINAL_VERSION}

RUN cd /go/src/github.com/lightninglabs/lightning-terminal && make build

FROM alpine:3.16

COPY --from=builder /go/src/github.com/lightninglabs/lightning-terminal/cmd/litd /bin/litd
COPY --from=builder /go/src/github.com/lightninglabs/lightning-terminal/cmd/litcli /bin/litcli

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 lit && \
    adduser lit -G lit --system --home /home --uid 1000

COPY entrypoint.sh /entrypoint.sh

EXPOSE 443

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["litd"]
