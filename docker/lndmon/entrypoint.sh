#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u lndmon)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lndmon
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" lndmon
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home lndmon
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g lndmon)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" lndmon
  fi
fi

if [ ! '$(stat -c %u "/home")' = "$(id -u lndmon)" ]; then
  chown -R lndmon:lndmon /home
fi

if [ "$1" = "lndmon" ]; then
  exec su-exec lndmon "$@"
else
  exec "$@"
fi
