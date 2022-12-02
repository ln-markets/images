# LN Markets Images

All the Bitcoin and lightning images used by [LN Markets](https://lnmarkets.com)

Images are built for __amd64__ and __arm64__ architectures.

## Configuration

Every image run the process as `satoshi` user.
You can change the default user id of `1000` and default group id of `1000`.
All default user home is set to `/home` to ease the use of volumes and mapping
If you change the `PUID` and `PGID` the `/home` folder permissions will be updated recursively.

| Name   | Description                           |
|--------|---------------------------------------|
| `PUID` | Set the user id running the app       |
| `PGID` | Set the user group id running the app |

## Images

We have a lot of images, you can find them all in the [Docker Hub](https://hub.docker.com/u/lnmarkets) or on the [GHCR](https://github.com/orgs/ln-markets/packages?repo_name=images).
Images are compiled and verified from the application github repository.

__Latest__ tag is the latest stable release from the app repository.
__nigthly__ tag is the latest commit from the app repository, the nightly images are built every 12 hours.

| Image                                                                     | Release/Latest                                                                                                                 | Nightly                                                                                               |
|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| [Bitcoin](https://github.com/bitcoin/bitcoin)                             | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bitcoin">                       | None                                                                                                  |
| [Bitcoin Regtest](./docker/bitcoin-regtest/README.md)                     | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/bitcoin-regtest">               | None                                                                                                  |
| [Lnd](https://github.com/lightningnetwork/lnd)                            | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnd/latest">                | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lnd">  |
| [Taro](https://github.com/lightninglabs/taro)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/taro/latest">               | <img alt="Docker Image Version (latest semver)" src="https://img.shields.io/docker/v/lnmarkets/taro"> |
| [Loop](https://github.com/lightninglabs/loop)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/loop/latest">               | None                                                                                                  |
| [Pool](https://github.com/lightninglabs/pool)                             | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/pool/latest">               | None                                                                                                  |
| [Faraday](https://github.com/lightninglabs/faraday)                       | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/faraday/latest">            | None                                                                                                  |
| [Lightning Terminal](https://github.com/lightninglabs/lightning-terminal) | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lightning-terminal/latest"> | None                                                                                                  |
| [Lndmon](https://github.com/lightninglabs/lndmon)                         | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/lndmon/latest">             | None                                                                                                  |
| [Tor](https://github.com/TheTorProject)                                   | <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/lnmarkets/tor/latest">                | None                                                                                                  |
