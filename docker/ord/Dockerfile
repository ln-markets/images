FROM rust:1.73-slim-bookworm AS builder

ARG VERSION

WORKDIR /app

RUN --mount=type=cache,target=/var/cache/apt \
    apt update -y && apt install -y \
    libssl-dev \
    git

RUN --mount=type=cache,target=/usr/local/cargo/registry,id=ord-registry \
    --mount=type=cache,target=/app/target,id=ord \
    git clone --depth 1 --single-branch --branch ${VERSION} https://github.com/ordinals/ord.git && \
    cd ord && \
    cargo build --release

FROM lnmarkets/debian:bookworm

ENV RUST_LOG=info

COPY --from=builder /app/ord/target/release/ord /usr/bin/ord

ENTRYPOINT [ "/docker/entrypoint.sh", "ord" ]
