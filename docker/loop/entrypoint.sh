#!/bin/sh

set -e

/docker/update-user.sh

if [ "$1" = "loopd" ] || [ "$1" = "loop" ]; then
  exec su-exec loop "$@"
else
  exec "$@"
fi
