#! /usr/bin/env sh

crond -b

# Create the bitcoin wallet if needed and load it in background
/bin/sh -c "sleep 2 && bitcoin-cli -regtest createwallet lnmarkets | true 2>/dev/null && bitcoin-cli -regtest loadwallet lnmarkets | true 2>/dev/null" &

bitcoind -conf=/conf/bitcoin.conf
