#! /usr/bin/env sh

ADDRESS=$(bitcoin-cli -regtest getnewaddress)
bitcoin-cli -regtest generatetoaddress 1 $ADDRESS
