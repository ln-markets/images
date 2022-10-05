FROM alpine:3.16

ENV CONF_PATH=/etc/tor/torrc

RUN apk update && \
    apk add tor su-exec shadow \
    bash

RUN addgroup --system tor && \
    addgroup tor tor && \
    userdel guest && \
    groupdel users

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9050 9051

VOLUME [ "/var/lib/tor" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "tor" ]
