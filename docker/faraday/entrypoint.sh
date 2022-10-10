#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "faraday" ] || [ "$1" = "frcli" ]; then
  exec su-exec satoshi "$@"
else
  exec "$@"
fi
