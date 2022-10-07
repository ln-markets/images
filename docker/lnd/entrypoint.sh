#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u lnd)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lnd
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" lnd
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home lnd
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g lnd)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" lnd
  fi
fi

if [ ! '$(stat -c %u "/home")' = "$(id -u lnd)" ]; then
  chown -R lnd:lnd /home
fi

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
