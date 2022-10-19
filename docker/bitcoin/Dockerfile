FROM lncm/berkeleydb:v4.8.30.NC AS berkleydb

FROM alpine:3.16 AS builder

ARG VERSION

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

RUN wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}.tar.gz

# Removed gpp signature verification
RUN wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS && \
    grep "bitcoin-${VERSION}.tar.gz\$" SHA256SUMS | sha256sum -c -

RUN tar -xzf bitcoin-${VERSION}.tar.gz

WORKDIR /opt/bitcoin-${VERSION}

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

FROM lnmarkets/base-alpine:3.16

ENV DATA_PATH=/home/.bitcoin

COPY --from=builder /opt/build/bin/* /bin/

RUN apk add --no-cache --update \
    boost-filesystem \
    boost-thread \
    libevent \
    libsodium \
    libstdc++ \
    libzmq \
    sqlite-libs

EXPOSE 8080
EXPOSE 8333 18333 18444
EXPOSE 8332 18332 18443
EXPOSE 28332 28333

ENTRYPOINT [ "/docker/entrypoint.sh", "bitcoind" ]
