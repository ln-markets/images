#!/usr/bin/env bash

set -e

if [ ! -z "$USER_ID" ]; then
    usermod -u $USER_ID tor
fi

if [ ! -z "$GROUP_ID" ]; then
    groupmod -g $GROUP_ID tor
fi

if [ $1 = "tor" ];then
    if [ ! "$USE_CONF" ]; then
        rm -f $CONF_PATH

        if [ ! -z "$PASSWORD" ]; then
            echo HashedControlPassword $(tor --hash-password "${PASSWORD}" | tail -n 1) >> /etc/tor/torrc
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

    su-exec tor tor -f $CONF_PATH --verify-config
    exec su-exec tor tor -f $CONF_PATH
else
    exec "$@"
fi
