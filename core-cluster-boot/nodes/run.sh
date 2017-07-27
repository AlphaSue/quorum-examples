#!/bin/bash

# stop if error
set -e

# utils
log() {
  echo "[$(date +"%T")] ${1}"
}

kill-if-running() {
  for p in "$@"; do
    if pgrep -x "$p" &>/dev/null; then
      log "$p is already running; killing..."
      killall $p
    fi
  done
}


# constants
BOOTNODE_URL="127.0.0.1:10000"
BOOTNODE_ADDR="enode://$(cat bootnode/addr)@${BOOTNODE_URL}"
NETWORK_ID="30"
ARGS="--bootnodes $BOOTNODE_ADDR --networkid $NETWORK_ID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"


# kill nodes if already running
kill-if-running bootnode constellation-node geth


# start bootnode
log "starting bootnode..."
bootnode -nodekey bootnode/bootkey --addr ${BOOTNODE_URL} &>/dev/null &


# start constellation 1
log "starting constellation for node 1 on port 9000..."
constellation-node constellation/node.conf &>/dev/null &

# start constellation 2
log "starting constellation for node 2 on port 9001..."
constellation-node constellation2/node.conf &>/dev/null &


# start node 1
log "copying static-nodes to node"
cp -rf static-nodes.json node/

log "starting node at 127.0.0.1:33000 (8545)..."
geth --datadir node $ARGS --port 33000 \
  --verbosity 5 \
  --voteaccount "0xed9d02e382b34818e88b88a309c7fe71e65f419d" --votepassword "" \
  --blockmakeraccount "0xca843569e3427144cead5e4d5999a3d0ccf92b8e" \
  --blockmakerpassword "" &>/dev/null &

# start node 2
log "copying static-nodes to node2"
cp -rf static-nodes.json node/

log "starting node at 127.0.0.1:33000 (8545)..."
geth --datadir node2 $ARGS --port 33000 --rpcport 8545 \
  --verbosity 5 \
  --blockmakeraccount "0xa0efc843a204d1ccdb1854b2735f064e9bfdd18f" \
  --blockmakerpassword "" &>/dev/null &

if [ "$1" == "console" ]; then

  ATTACH_NODE=${2-node}

  log "waiting 3s for node to start"
  sleep 3
  geth attach ${ATTACH_NODE}/geth.ipc

fi

