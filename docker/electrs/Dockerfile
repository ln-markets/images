ARG VERSION

FROM rust:bookworm AS build

WORKDIR /app

ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib

RUN apt update -qqy && \
    apt install -qqy librocksdb-dev curl clang cmake git

RUN git clone https://github.com/romanz/electrs.git && \
    cd electrs && \
    git checkout $VERSION && \
    cargo install --locked --path .

FROM lnmarkets/debian:bookworm

COPY --from=build /usr/local/cargo/bin/electrs /usr/bin/electrs

RUN apt update -qqy && \
    apt install -qqy librocksdb-dev

EXPOSE 50001 4224

ENTRYPOINT [ "/docker/entrypoint.sh", "electrs"]
