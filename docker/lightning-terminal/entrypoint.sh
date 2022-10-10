#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "litd" ] || [ "$1" = "lit" ]; then
  exec su-exec lit "$@"
else
  exec "$@"
fi
