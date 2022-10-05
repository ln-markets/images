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
      usermod -d /taro taro
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g taro)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" taro
  fi
fi

if [ ! '$(stat -c %u "/taro")' = "$(id -u taro)" ]; then
  chown -R taro:taro /taro
else
  echo "/taro user and group is good !"
fi

if [ ! -z "${BITCOIND_RPCPASS}" ] && [ -f $taro_CONF_PATH ] && grep -q BITCOIND_RPCPASS $taro_CONF_PATH; then
  sed "s/BITCOIND_RPCPASS/$BITCOIND_RPCPASS/g" $taro_CONF_PATH > tmp.conf
  cat tmp.conf > $taro_CONF_PATH
  rm tmp.conf
fi

if [ ! -z "${TOR_PASSWORD}" ] && [ -f $taro_CONF_PATH ] && grep -q TOR_PASSWORD $taro_CONF_PATH; then
  sed "s/TOR_PASSWORD/$TOR_PASSWORD/g" $taro_CONF_PATH > tmp.conf
  cat tmp.conf > $taro_CONF_PATH
  rm tmp.conf
fi

if [ "$1" = "taro" ] || [ "$1" = "lncli" ]; then
  exec su-exec taro "$@"
else
  exec "$@"
fi
