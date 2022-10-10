#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "poold" ] || [ "$1" = "pool" ]; then
  exec su-exec pool "$@"
else
  exec "$@"
fi
