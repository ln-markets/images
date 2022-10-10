ARG BITCOIN_REGTEST_VERSION=23.0

FROM lnmarkets/bitcoin:${BITCOIN_REGTEST_VERSION}

RUN apk add --update --no-cache \
    dcron \
    bash \
    libcap

RUN chown satoshi:satoshi /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/sbin/crond

COPY ./regtest.sh ./docker/regtest.sh

ENTRYPOINT ["/docker/regtest.sh"]
