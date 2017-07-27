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
if [ ! -e "constellation/node.key" ]; then
    log "preparing constellation for node..."
    constellation-node --generatekeys=constellation/node
fi

log "starting constellation node on port 9000..."
constellation-node constellation/node.conf &>/dev/null &

# start geth
if [ ! -d "node/geth" ]; then
    mkdir -p node
    log "preparing node..."
    geth --datadir node init genesis.json
fi

log "copying static-nodes for node"
cp -rf static-nodes.json node/

if [ "$1" == "console" ]; then
  log "starting node..."
  geth --datadir node $ARGS --port 33000 --verbosity 3 \
    --voteaccount "898b1d83a80871b599675cdbf0a221fe394e5ffb" --votepassword "" \
    --blockmakeraccount "0xa3436ff6f950604649ac5172bc527f88f99bd68d" \
    --blockmakerpassword "" \
    &>/dev/null &

  log "waiting 3 seconds for node to start..."
  sleep 3
  geth attach node/geth.ipc

else
  log "starting node..."
  geth --datadir node $ARGS --port 33000 --verbosity 3 \
    --voteaccount "898b1d83a80871b599675cdbf0a221fe394e5ffb" --votepassword "" \
    --blockmakeraccount "0xa3436ff6f950604649ac5172bc527f88f99bd68d" \
    --blockmakerpassword ""

fi
