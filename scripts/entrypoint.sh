#!/bin/sh

set -e

/docker/update-user.sh

exec su -s /bin/bash satoshi -c "$(echo "$@")"