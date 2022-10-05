FROM alpine:3.16 as builder

ENV POOL_VERSION=v0.5.7-alpha

WORKDIR /opt

RUN apk --no-cache add \
    bash \
    ca-certificates \
    gnupg \
    perl-utils

RUN wget https://github.com/lightninglabs/pool/releases/download/${POOL_VERSION}/pool-linux-amd64-${POOL_VERSION}.tar.gz
RUN wget https://github.com/lightninglabs/pool/releases/download/${POOL_VERSION}/manifest-${POOL_VERSION}.txt
RUN wget https://github.com/lightninglabs/pool/releases/download/${POOL_VERSION}/manifest-${POOL_VERSION}.sig

RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F4FC70F07310028424EFC20A8E4256593F177720 && \
    gpg --verify manifest-${POOL_VERSION}.sig manifest-${POOL_VERSION}.txt && \
    cat  manifest-${POOL_VERSION}.txt | grep -q "$(shasum -a 256 pool-linux-amd64-${POOL_VERSION}.tar.gz)"

RUN tar -xvzf pool-linux-amd64-${POOL_VERSION}.tar.gz

FROM alpine:3.16 as final


COPY --from=builder /opt/pool-linux-amd64-${POOL_VERSION}/pool /usr/local/bin/
COPY --from=builder /opt/pool-linux-amd64-${POOL_VERSION}/poold /usr/local/bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 pool
RUN adduser pool --system --uid 1000 --home /pool -G pool

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 12010 8281

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["poold"]
