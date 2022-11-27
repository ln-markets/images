# Bitcoin Regtest

This app is a simple bitcoin regtest node with auto-mining enabled.
The node will mine 1 block every 30 seconds

You can disable the auto-mining by setting the `CRON_MINE_BTC` env variable to `false`

The bitcoin node rpc is listening on port `18443`, to connect to the rpc use `satoshi` as username and `satoshi` as password
The zmq port are `28334` for raw blocks and `28335` for raw transactions

You can use the `mine` command to mine a specific amount of blocks

```bash
docker exec -it bitcoin-regtest mine 10
```
