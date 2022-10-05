FROM alpine:3.16 as berkleydb

# https://github.com/bitcoin/bitcoin/blob/master/contrib/install_db4.sh

ARG CORE_COUNT=4

ENV BERKLEY_DB_VERSION=4.8.30.NC
ENV BERKLEY_DB_HASH=12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef

RUN apk update && apk add \
    autoconf \
    automake \
    libtool \
    outils-sha256 \
    build-base

WORKDIR /opt

RUN wget https://download.oracle.com/berkeley-db/db-${BERKLEY_DB_VERSION}.tar.gz
RUN echo "${BERKLEY_DB_HASH} db-${BERKLEY_DB_VERSION}.tar.gz" | sha256 -c || exit 1
RUN tar -xzf db-${BERKLEY_DB_VERSION}.tar.gz

WORKDIR /opt/db-${BERKLEY_DB_VERSION}

# https://gist.github.com/danieldk/5700533

RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i dbinc/atomic.h

WORKDIR /opt/db-${BERKLEY_DB_VERSION}/build_unix

RUN  ../dist/configure --enable-cxx --disable-shared --disable-replication --with-pic --prefix=/opt/berkleydb
RUN make -j ${CORE_COUNT}
RUN make install

FROM alpine:3.16 as bitcoin

ARG CORE_COUNT=4
ENV BITCOIN_VERSION=23.0

WORKDIR /opt

COPY --from=berkleydb /opt/berkleydb /opt/berkleydb

RUN apk update && apk add \
    make \
    file \
    autoconf \
    automake \
    build-base \
    libtool \
    boost-system \
    boost-program_options \
    boost-filesystem \
    boost-dev \
    libressl-dev \ 
    libevent-dev \
    zeromq-dev  \
    gnupg \
    sqlite-dev

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz

# Removed gpp signature verification

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS && \
    grep "bitcoin-${BITCOIN_VERSION}.tar.gz\$" SHA256SUMS | sha256sum -c -

RUN tar -xzf bitcoin-${BITCOIN_VERSION}.tar.gz

WORKDIR /opt/bitcoin-${BITCOIN_VERSION}

RUN ./autogen.sh && \
    ./configure BDB_LIBS="-L/opt/berkleydb/lib -ldb_cxx-4.8" BDB_CFLAGS="-I/opt/berkleydb/include" \
    --prefix=/opt/build \
    --enable-hardening \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --without-gui \
    --without-miniupnpc \
    --with-utils \
    --with-libs \
    --with-daemon \
    --with-zmq

RUN make -j ${CORE_COUNT} && make install

RUN strip /opt/build/bin/bitcoind && \
    strip /opt/build/bin/bitcoin-tx && \
    strip /opt/build/bin/bitcoin-wallet

FROM alpine:3.16

LABEL maintainer="victor@lnmarkets.com"

ENV BITCOIN_VERSION=23.0

COPY --from=bitcoin /opt/build/bin/* /usr/local/bin/

RUN addgroup --system --gid 1000 bitcoin && \
    adduser --system --home /bitcoin -G bitcoin --uid 1000 bitcoin

RUN apk add \
    boost \
    libevent \
    libressl \
    libzmq \
    su-exec \
    shadow \
    sqlite

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18444

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["bitcoind"]
