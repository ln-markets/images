ARG VERSION

FROM debian:${VERSION}-slim

RUN addgroup --gid 1000 satoshi && \
    adduser --home /home --uid 1000 --gid 1000 satoshi && \
    chown -R satoshi:satoshi /home

RUN apt-get update && \
    apt-get install -y netcat-traditional && \
    rm -rf /var/lib/apt/lists/*

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint.sh /docker/entrypoint.sh

ENTRYPOINT [ "/docker/entrypoint.sh", "bash"]
