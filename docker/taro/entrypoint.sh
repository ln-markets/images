#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "taro" ] || [ "$1" = "lncli" ]; then
  exec su-exec satoshi "$@"
else
  exec "$@"
fi
