ARG BITCOIN_REGTEST_VERSION=23.0

FROM lnmarkets/bitcoin:${BITCOIN_REGTEST_VERSION}

RUN apk add --update --no-cache \
    dcron \
    bash \
    libcap

RUN chown bitcoin:bitcoin /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/sbin/crond

COPY ./regtest.sh ./scripts/regtest.sh

ENTRYPOINT ["/scripts/regtest.sh"]
