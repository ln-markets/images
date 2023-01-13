#!/bin/sh

set -e

/docker/update-user.sh

apk add dumb-init

su-exec satoshi dumb-init $@
