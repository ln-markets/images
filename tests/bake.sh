#! /usr/bin/env bash

# $1 is the name of the containe
# $2 is the type of bake, release or nightly

docker buildx bake \
    --set *.output="type=registry" \
    --file docker/$1/image.hcl \
    --file docker-bake.hcl \
    $2
