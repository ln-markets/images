ARG BP_NODE_TAG=latest
ARG LNP_NODE_TAG=latest
ARG RGB_NODE_TAG=latest
ARG STORM_NODE_TAG=latest
ARG STORM_STORED_TAG=latest
ARG BP_CORE_TAG=latest
ARG RGB_STD_TAG=latest
ARG RGB20_TAG=latest
ARG DESCRIPTOR_WALLET_TAG=latest

FROM lnmarkets/bp-node:$BP_NODE_TAG                        as bp-node
FROM lnmarkets/lnp-node:$LNP_NODE_TAG                      as lnp-node
FROM lnmarkets/rgb-node:$RGB_NODE_TAG                      as rgb-node
FROM lnmarkets/storm-node:$STORM_NODE_TAG                  as storm-node
FROM lnmarkets/storm-stored:$STORM_STORED_TAG              as storm-stored
FROM lnmarkets/bp-core:$BP_CORE_TAG                        as bp-core
FROM lnmarkets/rgb-std:$RGB_STD_TAG                        as rgb-std
FROM lnmarkets/rgb20:$RGB20_TAG                            as rgb20
FROM lnmarkets/bp-descriptor-wallet:$DESCRIPTOR_WALLET_TAG as descriptor-wallet

FROM bitnami/minideb:bullseye as final

ARG BIN_DIR=/bin/

COPY --from=bp-node           $BIN_DIR/bp-cli    $BIN_DIR
COPY --from=lnp-node          $BIN_DIR/lnp-cli   $BIN_DIR
COPY --from=rgb-node          $BIN_DIR/rgb-cli   $BIN_DIR
COPY --from=storm-node        $BIN_DIR/storm-cli $BIN_DIR
COPY --from=storm-stored      $BIN_DIR/store-cli $BIN_DIR
COPY --from=bp-core           $BIN_DIR/dbc       $BIN_DIR
COPY --from=bp-core           $BIN_DIR/seals     $BIN_DIR
COPY --from=rgb-std           $BIN_DIR/rgb       $BIN_DIR
COPY --from=rgb20             $BIN_DIR/rgb20     $BIN_DIR
COPY --from=descriptor-wallet $BIN_DIR/btc-cold  $BIN_DIR
COPY --from=descriptor-wallet $BIN_DIR/btc-hot   $BIN_DIR