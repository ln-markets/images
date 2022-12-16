# LN Markets Images

Images are built for **amd64** and **arm64** architectures.

## Configuration

Every image runs the process as `satoshi` user (`1000:1000`), with home directory located at `/home`.
You can easily change the user ID and group ID using the `PUID` and `PGID` environment variables, the `/home` folder permissions will be updated accordingly.

| Name   | Description                           |
| ------ | ------------------------------------- |
| `PUID` | Set the user ID running the app       |
| `PGID` | Set the user group ID running the app |

## Images

We have a lot of images, you can find them all in the [Docker Hub](https://hub.docker.com/u/lnmarkets) or on the [GHCR](https://github.com/orgs/ln-markets/packages?repo_name=images).
Images are compiled and verified from the application github repository.

**latest** tag is the latest stable release from the app repository.
**nigthly** tag is the latest commit from the app repository, the nightly images are built every 12 hours.

| Image                                                                     | Release/Latest                                                                                                                 | Nightly                                                                                                       |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| [Bitcoin](https://github.com/bitcoin/bitcoin)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bitcoin/latest">            | None                                                                                                          |
| [Bitcoin Regtest](./docker/bitcoin-regtest/README.md)                     | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bitcoin-regtest/latest">    | None                                                                                                          |
| [LND](https://github.com/lightningnetwork/lnd)                            | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnd/latest">                | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnd">          |
| [Taro](https://github.com/lightninglabs/taro)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/taro/latest">               | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/taro">         |
| [Loop](https://github.com/lightninglabs/loop)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/loop/latest">               | None                                                                                                          |
| [Pool](https://github.com/lightninglabs/pool)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/pool/latest">               | None                                                                                                          |
| [Faraday](https://github.com/lightninglabs/faraday)                       | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/faraday/latest">            | None                                                                                                          |
| [Lightning Terminal](https://github.com/lightninglabs/lightning-terminal) | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lightning-terminal/latest"> | None                                                                                                          |
| [Lndmon](https://github.com/lightninglabs/lndmon)                         | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lndmon/latest">             | None                                                                                                          |
| [Tor](https://github.com/TheTorProject)                                   | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/tor/latest">                | None                                                                                                          |
| [LNP Node](https://github.com/LNP-WG/lnp-node)                            | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnp-node/latest">           | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnp-node">     |
| [BP Node](https://github.com/BP-WG/bp-node)                               | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bp-node/latest">            | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bp-node">      |
| [RGB Node](https://github.com/RGB-WG/rgb-node)                            | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/rgb-node/latest">           | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/rgb-node">     |
| [Storm Node](https://github.com/STORM-WG/storm-node)                      | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/storm-node/latest">         | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/storm-node">   |
| [Storm Store Daemon](https://github.com/STORM-WG/storm-stored)            | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/storm-stored/latest">       | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/storm-stored"> |
| [nostr-rs-relay](https://github.com/scsibug/nostr-rs-relay)               | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/nostr-rs-relay/latest">     | None                                                                                                          |

### CLI Tools

| Image                                                           | CLI Tools                                                                                                       | Release/Latest                                                                                                                   | Nightly                                                                                                               |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| [BP Core](https://github.com/BP-WG/bp-core)                     | `dbc`, `seals`                                                                                                  | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bp-core/latest">              | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bp-core">              |
| [Descriptor Wallet](https://github.com/BP-WG/descriptor-wallet) | `btc-hot`, `btc-cold`                                                                                           | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bp-descriptor-wallet/latest"> | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bp-descriptor-wallet"> |
| [RGB20](https://github.com/RGB-WG/rust-rgb20)                   | `rgb20`                                                                                                         | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/rgb20/latest">                | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/rgb20">                |
| [RGB](https://github.com/RGB-WG/rgb-std)                        | `rgb`                                                                                                           | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/rgb-std/latest">              | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/rgb-std">              |
| LNP-BP Tools                                                    | `dbc`, `seals`, `btc-hot`, `btc-cold`, `rgb20`, `rgb`, `lnp-cli`, `bp-cli`, `rgb-cli`, `storm-cli`, `store-cli` | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnpbp-tools/latest">          | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnpbp-tools">          |
