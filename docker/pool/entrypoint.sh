#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u pool)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome pool
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" pool
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /pool pool
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g pool)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" pool
  fi
fi

if [ ! '$(stat -c %u "/pool")' = "$(id -u pool)" ]; then
  chown -R pool:pool /pool
fi

if [ "$1" = "poold" ] || [ "$1" = "pool" ]; then
  exec su-exec pool "$@"
else
  exec "$@"
fi
