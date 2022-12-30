ARG VERSION
ARG COMMIT

FROM node:18-alpine3.16 AS build

RUN apk add --no-cache git

WORKDIR /build

RUN git clone https://github.com/Cameri/nostream.git /build && \
    if [[ -z "$COMMIT" ]] || [ "$COMMIT" = "null" ] ; then git checkout ${VERSION} ; else git checkout ${COMMIT} ; fi

RUN npm install

RUN npm run build

FROM lnmarkets/base-node:18.12.1

WORKDIR /app

ENV DB_HOST=localhost
ENV DB_PORT=5432
ENV DB_NAME=postgres
ENV DB_USER=postgres
ENV DB_PASSWORD=postgres

ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV REDIS_USER=
ENV REDIS_PASSWORD=

COPY --from=build /build/dist .

RUN npm install --omit=dev --quiet

COPY ./scripts/entrypoint-node.sh /docker/entrypoint.sh

ENTRYPOINT [ "/docker/entrypoint.sh", "node src/index.js" ]
