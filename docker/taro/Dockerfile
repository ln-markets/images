FROM golang:1.19.2-alpine as taro

ENV TARO_VERSION=v0.1.0-alpha
ENV OS linux
ENV ARCH amd64

RUN apk add --no-cache --update \
    alpine-sdk \
    gnupg \
    make \
    gcc \
    perl-utils \
    bash

WORKDIR /opt

RUN git clone https://github.com/lightninglabs/taro.git && \
    cd taro && \
    make

FROM alpine:3.16

LABEL maintainer="victor@lnmarkets.com"

COPY --from=taro /opt/taro/tarod-debug /usr/local/bin/tarod
COPY --from=taro /opt/taro/tarocli-debug /usr/local/bin/tarocli

RUN apk add \
    su-exec \
    shadow

RUN addgroup --system --gid 10000 taro
RUN adduser taro --system --uid 10000 --home /taro -G taro

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 10029 8089

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["tarod"]
