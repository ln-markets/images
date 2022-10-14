ARG VERSION

FROM lnmarkets/bitcoin:${VERSION}

ENV CRON_MINE_BTC=1

RUN apk add --update --no-cache \
    dcron \
    bash \
    libcap

RUN chown satoshi:satoshi /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/sbin/crond

COPY docker/bitcoin-regtest/regtest.sh ./docker/regtest.sh

ENTRYPOINT ["/docker/regtest.sh"]
