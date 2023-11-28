ARG VERSION

# TODO: build it ourselves
FROM elementsproject/lightningd:${VERSION} as builder

FROM lnmarkets/debian:bookworm

RUN apt update -y && apt install -y \
    libpq-dev \
    python3

COPY --from=builder /usr/local/bin/lightningd /usr/local/bin/lightningd
COPY --from=builder /usr/local/bin/lightning-cli /usr/local/bin/lightning-cli
COPY --from=builder /usr/local/bin/lightning-hsmtool /usr/local/bin/lightning-hsmtool
COPY --from=builder /usr/local/libexec/c-lightning /usr/local/libexec/c-lightning

EXPOSE 9735 9835

ENTRYPOINT [ "/docker/entrypoint.sh", "lightningd" ]
