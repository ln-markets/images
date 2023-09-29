#!/usr/bin/env bash

set -e

address=$(bitcoin-cli -regtest getnewaddress)
blocks=1

print_usage() {
    echo "mine [arguments] (Must be run as satoshi user)"
    echo " "
    echo "options:"
    echo "-h        show brief help"
    echo "-a        address to send mined bitcoin to"
    echo "-b        number of blocks to mine"
    exit 0
}

while getopts 'ha:b:' flag; do
    case "${flag}" in
        a) address="${OPTARG}" ;;
        b) blocks="${OPTARG}" ;;
        h) print_usage
    esac
done

bitcoin-cli -regtest generatetoaddress $blocks $address
