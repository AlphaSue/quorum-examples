#!/bin/bash

# stop if error
set -e

# utils
log() {
  echo "[$(date +"%T")] ${1}"
}

# constants
BOOTNODE_URL="127.0.0.1:10000"
BOOTNODE_ADDR="enode://$(cat bootnode/addr)@${BOOTNODE_URL}"
NETWORK_ID="30"
ARGS="--bootnodes $BOOTNODE_ADDR --networkid $NETWORK_ID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

# start constellation
log "starting constellation node on port 9000..."
constellation-node constellation/node.conf &>/dev/null &

# start bootnode
log "starting boot node at ${BOOTNODE_URL}..."
bootnode -nodekey bootnode/bootkey --addr ${BOOTNODE_URL} &>/dev/null &

# start geth
log "starting node..."
geth --datadir node $ARGS --port 33000 \
  --verbosity 5 \
  --voteaccount "0xed9d02e382b34818e88b88a309c7fe71e65f419d" --votepassword "" \
  --blockmakeraccount "0xca843569e3427144cead5e4d5999a3d0ccf92b8e" \
  --blockmakerpassword "" #&>/dev/null &