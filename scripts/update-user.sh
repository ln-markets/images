#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ $(id -u ${USER}) -ne $PUID ]; then
    echo "Changing ${USER} user id to ${PUID}"
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome ${USER}
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" ${USER}
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /home ${USER}
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ $(id -g ${USER}) -ne $PGID ]; then
    echo "Changing ${USER} group to ${PGID}"
    groupmod -o -g "${PGID}" ${USER}
  fi
fi

if [ $(stat -c %u "/home") -ne $(id -u ${USER}) ]; then
  echo "Updating permissions on /home"
  chown ${USER}:${USER} /home

  if [ ! -z "${DATA_PATH}" ]; then
    if [ ! -d "$DATA_PATH" ]; then
      mkdir -p $DATA_PATH
    fi

    echo "Updating permissions recursivly on ${DATA_PATH}"
    chown -R ${USER}:${USER} ${DATA_PATH}
  fi
fi
