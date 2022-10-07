#! /usr/bin/env bash

set -e

BITCOIN_CONF_FILE=/home/.bitcoin/bitcoin.conf

mkdir -p /home/.bitcoin/
touch ${BITCOIN_CONF_FILE}

cat > /home/mine.sh << 'EOF'
#! /usr/bin/env bash

if [ -a /home/satoshi ]; then
    bitcoin-cli -regtest generatetoaddress 1 $(cat /home/satoshi)
fi
EOF

cat >${BITCOIN_CONF_FILE} << 'EOF'
server=1
regtest=1
txindex=1
listen=1
listenonion=0
dnsseed=0
upnp=0
zmqpubrawblock=tcp://0.0.0.0:28334
zmqpubrawtx=tcp://0.0.0.0:28335
fallbackfee=0.0002

[regtest]
rpcbind=0.0.0.0
rpcallowip=0.0.0.0/0
rpcport=18443
rpcuser=bitcoin
rpcpassword=bitcoin
EOF

cat > /home/crontab << 'EOF'
* * * * * /home/mine.sh
* * * * * sleep 30 && /home/mine.sh
EOF

chmod +x /home/mine.sh
chown -R bitcoin:bitcoin /home

# Must be run as root
crontab -u bitcoin /home/crontab
crond -b

# Create the bitcoin wallet if needed and load it in background
create_and_load_wallet() {
    # Sleep because we have to wait for bitcoind to start
    sleep 2
    if [ ! -a /home/.bitcoin/regtest/wallets/satoshi/wallet.dat ]; then
        echo 'Create default wallet'
        su-exec bitcoin bash -c "bitcoin-cli -regtest createwallet satoshi"
    fi

    su-exec bitcoin bash -c "bitcoin-cli -regtest loadwallet satoshi 2>/dev/null" | true

    # Create one address for the wallet where all coins will be mined
    if [ ! -a /home/satoshi ]; then
        echo 'Create satoshi address'
        su-exec bitcoin bash -c "bitcoin-cli -regtest getnewaddress > /home/satoshi"
    fi
}

# Run create_and_load_wallet in background 
create_and_load_wallet &

su-exec bitcoin bitcoind
