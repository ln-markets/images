ARG COMMIT

ARG SRC_DIR=/usr/local/src/mempool-electrs
ARG BUILDER_DIR=/srv/mempool-electrs

# Clone the repository and checkout the specified commit or version
FROM debian:bookworm-slim as repo

ARG SRC_DIR
ARG COMMIT

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/mempool/electrs ${SRC_DIR} && \
    cd ${SRC_DIR}  && \
    git checkout ${COMMIT}

# This image uses cargo-chef to build the application in order to compile
# the dependencies apart from the main application. This allows the compiled
# dependencies to be cached in the Docker layer and greatly reduces the
# build time when there isn't any dependency changes.
#
# https://github.com/LukeMathWalker/cargo-chef
# Base image
FROM lukemathwalker/cargo-chef:0.1.67-rust-1.79.0-bookworm AS chef

ARG SRC_DIR

RUN apt update -qqy && \
    apt install -qqy build-essential librocksdb-dev curl clang cmake git

WORKDIR $SRC_DIR

# Cargo chef step that analyzes the project to determine the minimum subset of
# files (Cargo.lock and Cargo.toml manifests) required to build it and cache
# dependencies
FROM chef AS planner

ARG SRC_DIR

COPY --from=repo $SRC_DIR $SRC_DIR
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder

ARG SRC_DIR
ARG BUILDER_DIR

COPY --from=planner "${SRC_DIR}/recipe.json" recipe.json

# Build dependencies - this is the caching Docker layer
RUN cargo chef cook --release --recipe-path recipe.json --target-dir "${BUILDER_DIR}"

# Copy all files and build application
COPY --from=repo $SRC_DIR $SRC_DIR
RUN cargo build --release --target-dir "${BUILDER_DIR}" --bin electrs

# Final image with binaries
FROM lnmarkets/debian:bookworm as final

ARG BUILDER_DIR

COPY --from=builder --chown=satoshi:satoshi "${BUILDER_DIR}/release/electrs" /bin/

RUN apt update -qqy && \
    apt install -qqy librocksdb-dev

EXPOSE 50001 4224

ENTRYPOINT [ "/docker/entrypoint.sh", "electrs"]
