#!/usr/bin/env bash

set -e

CONF_PATH=/etc/tor/torrc

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u toruser)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome toruser
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" toruser
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home toruser
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g tor)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" tor
  fi
fi

if [ ! '$(stat -c %u "/home")' = "$(id -u tor)" ]; then
  chown -R tor:tor /home
fi

if [ $1 = "tor" ];then
    if [ ! "$ENV_CONFIG" ]; then
      echo "Deleting default torrc"
      rm -f $CONF_PATH
      
      if [ ! -z "$PASSWORD" ]; then
          echo HashedControlPassword $(tor --hash-password "${PASSWORD}" | tail -n 1) >> $CONF_PATH
      fi

      for tor_options in $(printenv | grep TOR_)
      do
          options="${tor_options:4}"
          readarray -d = -t options <<< "$options"
          option=${options[0]}
          value=${options[1]}
          echo $option $value >> $CONF_PATH
      done
    fi

    if test -f "$CONF_PATH"; then
      su-exec toruser tor -f $CONF_PATH --verify-config
      exec su-exec toruser tor -f $CONF_PATH
    fi

    exec su-exec toruser tor
else
    exec "$@"
fi
