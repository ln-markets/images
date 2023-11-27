ARG VERSION

FROM debian:${VERSION}-slim

RUN addgroup --gid 1000 satoshi && \
    adduser --home /home --uid 1000 --gid 1000 satoshi && \
    chown -R satoshi:satoshi /home

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint.sh /docker/entrypoint.sh

ENTRYPOINT [ "/docker/entrypoint.sh", "bash"]
