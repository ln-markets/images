#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u faraday)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome faraday
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" faraday
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /faraday faraday
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g faraday)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" faraday
  fi
fi

if [ ! '$(stat -c %u "/faraday")' = "$(id -u faraday)" ]; then
  chown -R faraday:faraday /faraday
else
  echo "/faraday user and group is good !"
fi

if [ "$1" = "faraday" ] || [ "$1" = "frcli" ]; then
  exec su-exec faraday "$@"
else
  exec "$@"
fi
