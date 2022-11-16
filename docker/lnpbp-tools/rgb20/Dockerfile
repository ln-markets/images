ARG VERSION
ARG COMMIT

ARG SRC_DIR=/usr/local/src/rgb20
ARG BUILDER_DIR=/srv/rgb20

# Clone the repository and checkout the specified commit or version
FROM debian:bullseye-slim as repo

ARG SRC_DIR
ARG VERSION
ARG COMMIT

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/RGB-WG/rust-rgb20 ${SRC_DIR} && \
    cd ${SRC_DIR}  && \
    if [[ -z "$RGB20_COMMIT" ]] ; then git checkout ${RGB20_COMMIT} ; else git checkout ${RGB20_COMMIT} ; fi

# This image uses cargo-chef to build the application in order to compile
# the dependencies apart from the main application. This allows the compiled
# dependencies to be cached in the Docker layer and greatly reduce the
# build time when there isn't any dependency changes.
#
# https://github.com/LukeMathWalker/cargo-chef
FROM lukemathwalker/cargo-chef:0.1.47-rust-1.65.0-slim-bullseye AS chef

ARG SRC_DIR

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
RUN cargo build --release --target-dir "${BUILDER_DIR}" --bins --all-features

# Final image with binaries
FROM bitnami/minideb:bullseye as final

ARG BUILDER_DIR

RUN addgroup --gid 1000 satoshi && \
    adduser --home /home --uid 1000 --gid 1000 satoshi && \
    chown -R satoshi:satoshi /home

COPY --from=builder --chown=satoshi:satoshi "${BUILDER_DIR}/release/rgb20" /bin/

COPY ./scripts/update-user.sh /docker/update-user.sh
COPY ./scripts/entrypoint.sh /docker/entrypoint.sh

ENTRYPOINT [ "/docker/entrypoint.sh", "rgb20" ]
