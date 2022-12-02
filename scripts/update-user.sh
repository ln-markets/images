#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ $(id -u satoshi) -ne $PUID ]; then
    echo "Changing satoshi user id to ${PUID}"
    
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
  if [ $(id -g satoshi) -ne $PGID ]; then
    echo "Changing satoshi group to ${PGID}"
    groupmod -o -g "${PGID}" satoshi
  fi
fi

if [ $(stat -c %u "/home") -ne $(id -u satoshi) ]; then
  echo "Updating permissions on /home"
  chown satoshi:satoshi /home
fi

if [ ! -z "${DATA_PATH}" ]; then
  DATA_PATH="/home"
fi

if [ ! -d "$DATA_PATH" ]; then
  mkdir -p $DATA_PATH
fi

if [ $(stat -c %u "${DATA_PATH}") -ne $(id -u satoshi) ]; then
  echo "Updating permissions recursivly on ${DATA_PATH}"
  chown -R satoshi:satoshi ${DATA_PATH}
fi
