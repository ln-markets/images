#! /usr/bin/env bash

set -e

# Create the bitcoin wallet if needed and load it in background
create_and_load_wallet() {
    # Sleep because we have to wait for bitcoind to start
    sleep 2
    if [ ! -f /home/.bitcoin/regtest/wallets/satoshi/wallet.dat ]; then
        echo 'Create default wallet'
        bitcoin-cli -regtest createwallet satoshi
    fi

    bitcoin-cli -regtest loadwallet satoshi 2>/dev/null | true
}

# Mine 1 block every 30 seconds
mine_btc() {
    sleep 5 && mine -b 101
    while true; do
        sleep $MININING_INTERVAL && mine
    done
}

# Run create_and_load_wallet in background 
create_and_load_wallet &

if [ "$MINING" != "false" ]; then
    echo "Enable mining"
    mine_btc &
fi

mkdir -p /home/.bitcoin/regtest

# Auth for electrs https://github.com/romanz/electrs/issues/199#issuecomment-558319816
echo -n "satoshi:satoshi" > /home/.bitcoin/regtest/electrs.cookie

exec "$@"
