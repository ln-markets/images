#!/bin/sh

set -e

# Setup user/group ids
if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u satoshi)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome satoshi
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" satoshi
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home satoshi
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g satoshi)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" satoshi
  fi
fi

if [ ! '$(stat -c %u "/home")' = "$(id -u satoshi)" ]; then
  chown -R satoshi:satoshi /home
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  exec su-exec satoshi "$@"
fi

exec "$@"
