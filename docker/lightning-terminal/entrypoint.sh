#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u lit)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lit
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" lit
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /lit lit
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g lit)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" lit
  fi
fi

if [ ! '$(stat -c %u "/lit")' = "$(id -u lit)" ]; then
  chown -R lit:lit /lit
else
  echo "/lit user and group is good !"
fi

if [ "$1" = "litd" ] || [ "$1" = "lit" ]; then
  exec su-exec lit "$@"
else
  exec "$@"
fi
