ARG VERSION

FROM node:${VERSION}-alpine3.16

RUN apk add --no-cache --update \
    su-exec \
    shadow

RUN deluser --remove-home node

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint-alpine.sh /docker/entrypoint.sh
