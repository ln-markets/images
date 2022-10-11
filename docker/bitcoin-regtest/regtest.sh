#! /usr/bin/env bash

set -e

BITCOIN_CONF_FILE=/home/.bitcoin/bitcoin.conf

mkdir -p /home/.bitcoin/
touch ${BITCOIN_CONF_FILE}

cat > ${BITCOIN_CONF_FILE} << 'EOF'
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
rpcuser=satoshi
rpcpassword=satoshi
EOF

touch /home/crontab

if [ $CRON_MINE_BTC -eq 1 ]; then
    echo "Installing cron to mine 1 block every 30 seconds"
    cat > /home/crontab << 'EOF'
* * * * * /bin/mine
* * * * * sleep 30 && /bin/mine
EOF
fi

# Script has to be run as satoshi user
cat > /bin/mine << 'EOF'
#! /usr/bin/env bash

address=$(cat /home/address)
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
EOF

chmod +x /bin/mine
chown -R satoshi:satoshi /home

# Must be run as root
crontab -u satoshi /home/crontab
crond -b

# Create the bitcoin wallet if needed and load it in background
create_and_load_wallet() {
    # Sleep because we have to wait for bitcoind to start
    sleep 2
    if [ ! -f /home/.bitcoin/regtest/wallets/satoshi/wallet.dat ]; then
        echo 'Create default wallet'
        su-exec satoshi bash -c "bitcoin-cli -regtest createwallet satoshi"
    fi

    su-exec satoshi bash -c "bitcoin-cli -regtest loadwallet satoshi 2>/dev/null" | true

    # Create one address for the wallet where all coins will be mined by the script /bin/mine
    if [ ! -f /home/address ]; then
        echo 'Create default address'
        su-exec satoshi bash -c "bitcoin-cli -regtest getnewaddress > /home/address"
    fi
}

# Run create_and_load_wallet in background 
create_and_load_wallet &

su-exec satoshi bitcoind
