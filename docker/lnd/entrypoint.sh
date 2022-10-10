#!/bin/sh

set -e

/docker/update-user.sh

if [ ! -z "${BITCOIND_RPCPASS}" ] && [ -f $LND_CONF_PATH ] && grep -q BITCOIND_RPCPASS $LND_CONF_PATH; then
  sed "s/BITCOIND_RPCPASS/$BITCOIND_RPCPASS/g" $LND_CONF_PATH > tmp.conf
  cat tmp.conf > $LND_CONF_PATH
  rm tmp.conf
fi

if [ ! -z "${TOR_PASSWORD}" ] && [ -f $LND_CONF_PATH ] && grep -q TOR_PASSWORD $LND_CONF_PATH; then
  sed "s/TOR_PASSWORD/$TOR_PASSWORD/g" $LND_CONF_PATH > tmp.conf
  cat tmp.conf > $LND_CONF_PATH
  rm tmp.conf
fi

if [ "$1" = "lnd" ] || [ "$1" = "lncli" ]; then
  exec su-exec lnd "$@"
else
  exec "$@"
fi
