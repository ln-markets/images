FROM vafanassieff/bitcoin:23.0

RUN apk add --update busybox-suid

COPY --chown=bitcoin:bitcoin ./crontab /conf/crontab
COPY --chown=bitcoin:bitcoin ./start.sh ./scripts/start.sh
COPY --chown=bitcoin:bitcoin ./mine.sh ./scripts/mine.sh
COPY --chown=bitcoin:bitcoin ./bitcoin.conf /conf/bitcoin.conf

RUN /usr/bin/crontab /conf/crontab

CMD ["/scripts/start.sh"]
