#! /usr/bin/env bash

# $1 is the name of the containe
# $2 is the version of the application

docker build -f docker/$1/Dockerfile -t $1:$2 --build-arg VERSION=$2 .
