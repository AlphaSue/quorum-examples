#!/bin/bash

set -eu -o pipefail



# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

# install constellation
wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.0.1-alpha/ubuntu1604.zip
unzip ubuntu1604.zip
cp ubuntu1604/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
cp ubuntu1604/constellation-enclave-keygen /usr/local/bin && chmod 0755 /usr/local/bin/constellation-enclave-keygen
rm -rf ubuntu1604.zip ubuntu1604

# install golang
GOREL=go1.7.3.linux-amd64.tar.gz
wget -q https://storage.googleapis.com/golang/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
echo 'PATH=$PATH:/usr/local/go/bin' >> /home/ubuntu/.bashrc

# make/install quorum
git clone https://github.com/StentorTechnology/stentor-blockchain
pushd stentor-blockchain >/dev/null
# git checkout tags/v1.1.0
make all

cp build/bin/geth /usr/local/bin
cp build/bin/bootnode /usr/local/bin
popd >/dev/null

#clone example
git clone https://github.com/StentorTechnology/stentor-examples

# copy examples
cp -r /home/ubuntu/stentor-examples/vagrant2/bootnode/examples/7nodes /home/ubuntu/stentor-7nodes
chown -R ubuntu:ubuntu /home/ubuntu/stentor-7nodes
chmod +x /home/ubuntu/stentor-7nodes/*.sh

# done!
banner "Stentor"
echo
echo 'The Stentor vagrant instance has been provisioned. Examples are available in ~/stentor-examples inside the instance.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
