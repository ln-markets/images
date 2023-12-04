# Bitcoin Regtest

This app is a simple bitcoin regtest node with auto-mining enabled.

The node will mine the 101 first blocks instantly right after initialization, so that at least one coinbase is [mature](https://bitcoin.stackexchange.com/questions/1991/what-is-the-block-maturation-time) from the get go. Then, it will automatically mine 1 new block every 30 seconds.

You can disable the auto-mining by setting the `CRON_MINE_BTC` env variable to `false`. Note that it also disables the mining of the first 101 blocks.

The bitcoin node rpc is listening on port `18443`, to connect to the rpc use `satoshi` as username and `satoshi` as password
The zmq port are `28334` for raw blocks and `28335` for raw transactions

You can use the `mine` command to mine a specific amount of blocks

```bash
docker exec -it bitcoin-regtest mine -b 10
```
