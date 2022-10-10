#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "litd" ] || [ "$1" = "litcli" ]; then
  exec su-exec satoshi "$@"
else
  exec "$@"
fi
