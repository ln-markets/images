#!/bin/sh

set -e

/docker/update-user.sh

exec su-exec satoshi "$@"
