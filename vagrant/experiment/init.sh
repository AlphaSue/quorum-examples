#!/bin/bash

# utils
log() {
  echo "[$(date +"%T")] ${1}"
}

# configure bootnode
log "preparing bootnode..."
bootnode -addr localhost:22000 -genkey bootnode/bootkey -writeaddress > bootnode/addr

# configure node
log "preparing node..."
geth --datadir node init genesis.json
