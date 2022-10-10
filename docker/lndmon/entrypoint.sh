#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "lndmon" ]; then
  exec su-exec lndmon "$@"
else
  exec "$@"
fi
