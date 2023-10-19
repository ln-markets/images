ARG VERSION

FROM lnmarkets/bitcoin:${VERSION}

ENV MINING=true
ENV MININING_INTERVAL=30

RUN apk add --update --no-cache bash libcap

COPY --chown=satoshi:satoshi docker/bitcoin-regtest/bitcoin.conf /home/.bitcoin/bitcoin.conf

COPY --chown=satoshi:satoshi docker/bitcoin-regtest/mine.sh /usr/bin/mine

COPY --chown=satoshi:satoshi docker/bitcoin-regtest/entrypoint.sh /docker/entrypoint.sh

EXPOSE 18443 18444 28334 28335

USER satoshi

ENTRYPOINT ["/docker/entrypoint.sh"]

CMD ["bitcoind"]
