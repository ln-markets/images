#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u loop)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome loop
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" loop
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /loop loop
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g loop)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" loop
  fi
fi

if [ ! '$(stat -c %u "/loop")' = "$(id -u loop)" ]; then
  chown -R loop:loop /loop
else
  echo "/loop user and group is good !"
fi

if [ "$1" = "loopd" ] || [ "$1" = "loop" ]; then
  exec su-exec loop "$@"
else
  exec "$@"
fi
