#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u taro)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome taro
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" taro
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home taro
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g taro)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" taro
  fi
fi

if [ ! '$(stat -c %u "/home")' = "$(id -u taro)" ]; then
  chown -R taro:taro /home
fi

if [ "$1" = "taro" ] || [ "$1" = "lncli" ]; then
  exec su-exec taro "$@"
else
  exec "$@"
fi
