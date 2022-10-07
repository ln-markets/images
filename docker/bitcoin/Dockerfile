FROM lncm/berkeleydb:v4.8.30.NC AS berkleydb

FROM alpine:3.16 AS builder

ARG BITCOIN_VERSION=23.0

WORKDIR /opt

COPY --from=berkleydb /opt /opt

RUN apk add --no-cache \
    autoconf \
    automake \
    boost-dev \
    sqlite-dev \
    build-base \
    chrpath \
    file \
    libevent-dev \
    libressl \
    libtool \
    linux-headers \
    zeromq-dev

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz

# Removed gpp signature verification
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS && \
    grep "bitcoin-${BITCOIN_VERSION}.tar.gz\$" SHA256SUMS | sha256sum -c -

RUN tar -xzf bitcoin-${BITCOIN_VERSION}.tar.gz

WORKDIR /opt/bitcoin-${BITCOIN_VERSION}

RUN ./autogen.sh

RUN ./configure \
    BDB_LIBS="-L/opt/db4/lib -ldb_cxx-4.8" \
    BDB_CFLAGS="-I/opt/db4/include" \
    CXXFLAGS="-O2" \
    --prefix=/opt/build \
    --enable-hardening \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --disable-man \
    --enable-static \
    --enable-reduce-exports \
    --without-gui \
    --without-libs \
    --with-utils \
    --with-sqlite=yes \
    --with-daemon \
    --with-zmq

RUN make -j $(nproc) check

RUN make install

RUN strip /opt/build/bin/bitcoind && \
    strip /opt/build/bin/bitcoin-tx && \
    strip /opt/build/bin/bitcoin-wallet

FROM alpine:3.16

COPY --from=builder /opt/build/bin/* /bin/

RUN addgroup --system --gid 1000 satoshi && \
    adduser satoshi -G satoshi --system --home /home --uid 1000

RUN apk add --no-cache --update \
    boost-filesystem \
    boost-thread \
    libevent \
    libsodium \
    libstdc++ \
    libzmq \
    sqlite-libs \
    su-exec \
    shadow

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080
EXPOSE 8333 18333 18444
EXPOSE 8332 18332 18443
EXPOSE 28332 28333

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["bitcoind"]
