FROM golang:1.19.2-alpine as builder

ENV LIGHTNING_TERMINAL_VERSION=v0.8.0-alpha
ENV GODEBUG netdns=cgo
ENV GO111MODULE on

RUN apk --no-cache add \
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
    git clone https://github.com/lightninglabs/lightning-terminal.git /go/src/github.com/lightninglabs/lightning-terminal \
    && cd /go/src/github.com/lightninglabs/lightning-terminal \
    && git checkout ${LIGHTNING_TERMINAL_VERSION} && \
    git verify-tag ${LIGHTNING_TERMINAL_VERSION}  \
    && make build

FROM alpine:3.16 as final

COPY --from=builder /go/src/github.com/lightninglabs/lightning-terminal/cmd/litd /bin/
COPY --from=builder /go/src/github.com/lightninglabs/lightning-terminal/cmd/litcli /bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 lit
RUN adduser lit --system --uid 1000 --home /lit -G lit

COPY entrypoint.sh /entrypoint.sh

EXPOSE 443

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["litd"]
