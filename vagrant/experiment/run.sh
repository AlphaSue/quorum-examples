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
NETWORK_ID="30"
ARGS="--networkid $NETWORK_ID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

# kill nodes if already running
kill-if-running bootnode constellation-node geth

# start constellation
log "starting constellation node on port 9000..."
constellation-node constellation/node.conf &>/dev/null &

# start geth

# configure node
if [ -d "node/geth" ]; then
    log "preparing node..."
    geth --datadir node init genesis.json
fi

if [ "$1" == "console" ]; then
  log "starting node..."
  geth --datadir node $ARGS --port 33000 \
    --verbosity 5 \
    --voteaccount "0xed9d02e382b34818e88b88a309c7fe71e65f419d" --votepassword "" \
    --blockmakeraccount "0xca843569e3427144cead5e4d5999a3d0ccf92b8e" \
    --blockmakerpassword "" &>/dev/null &

  log "waiting 3 seconds for node to start..."
  sleep 3
  geth attach node/geth.ipc

else
  log "starting node..."
  geth --datadir node $ARGS --port 33000 \
    --verbosity 5 \
    --voteaccount "0xed9d02e382b34818e88b88a309c7fe71e65f419d" --votepassword "" \
    --blockmakeraccount "0xca843569e3427144cead5e4d5999a3d0ccf92b8e" \
    --blockmakerpassword "" #&>/dev/null &

fi
