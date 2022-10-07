#!/bin/sh

set -e

# Setup user/group ids
if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u bitcoin)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome bitcoin
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" bitcoin
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home bitcoin
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g bitcoin)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" bitcoin
  fi
fi

if [ ! '$(stat -c %u "/home")' = "$(id -u bitcoin)" ]; then
  chown -R bitcoin:bitcoin /home
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  exec su-exec bitcoin "$@"
fi

exec "$@"
