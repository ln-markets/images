#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  exec su-exec satoshi "$@"
fi

exec "$@"
