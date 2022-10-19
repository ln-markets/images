ARG VERSION

FROM alpine:${VERSION}

RUN apk add --no-cache --update \
    su-exec \
    shadow

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint-alpine.sh /docker/entrypoint.sh
