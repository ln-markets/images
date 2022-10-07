#! /usr/bin/env bash

set -e

BITCOIN_CONF_FILE=/bitcoin/.bitcoin/bitcoin.conf

mkdir -p /bitcoin/.bitcoin/
touch ${BITCOIN_CONF_FILE}

cat > /bitcoin/mine.sh << 'EOF'
#! /usr/bin/env bash

    if [ -a /bitcoin/satoshi ]; then
        bitcoin-cli -regtest generatetoaddress 1 $(cat /bitcoin/satoshi)
    fi
EOF

cat >${BITCOIN_CONF_FILE} << 'EOF'
server=1
regtest=1
listenonion=0
txindex=1
dnsseed=0
upnp=0
listen=1
logtimestamps=0
fallbackfee=0.0002
zmqpubrawblock=tcp://0.0.0.0:28334
zmqpubrawtx=tcp://0.0.0.0:28335

[regtest]
rpcbind=0.0.0.0
rpcallowip=0.0.0.0/0
rpcport=18443
rpcuser=bitcoin
rpcpassword=bitcoin
EOF

cat > /bitcoin/crontab << 'EOF'
* * * * * /bitcoin/mine.sh
* * * * * sleep 30 && /bitcoin/mine.sh
EOF

chmod +x /bitcoin/mine.sh
chown -R bitcoin:bitcoin /bitcoin

# Must be run as root
crontab -u bitcoin /bitcoin/crontab
crond -b

# Create the bitcoin wallet if needed and load it in background
create_and_load_wallet() {
    # Sleep because we have to wait for bitcoind to start
    sleep 2
    if [ ! -a /bitcoin/.bitcoin/regtest/wallets/lnmarkets/wallet.dat ]; then
        echo 'Create default wallet'
        su-exec bitcoin bash -c "bitcoin-cli -regtest createwallet lnmarkets"
    fi

    su-exec bitcoin bash -c "bitcoin-cli -regtest loadwallet lnmarkets 2>/dev/null" | true

    if [ ! -a /bitcoin/satoshi ]; then
        echo 'Create satoshi address'
        su-exec bitcoin bash -c "bitcoin-cli -regtest getnewaddress > /bitcoin/satoshi"
    fi
}

create_and_load_wallet &

# Start bitcoind
su-exec bitcoin bitcoind -conf=${BITCOIN_CONF_FILE}
