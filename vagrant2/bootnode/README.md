# Stentor Examples

This repository contains setup examples for stentor.

Current examples include:
* [7nodes](https://github.com/jpmorganchase/stentor-examples/tree/master/examples/7nodes): Starts up a fully-functioning stentor environment consisting of 7 independent nodes with a mix of block makers, voters, and unprivileged nodes. From this example one can test consensus, privacy, and all the expected functionality of an Ethereum platform.
* [permissions](https://github.com/jpmorganchase/stentor-examples/tree/master/examples/permissions): Focuses on how to add, remove, and update the list of nodes permitted to participate in the network.

The easiest way to get started with running the examples is to use the vagrant environment (see below).

**Important note**: Any account/encryption keys contained in this repository are for
demonstration and testing purposes only. Before running a real environment, you should
generate new ones using Geth's `account` tool and `constellation-enclave-keygen`.

## Vagrant Usage

This is a complete Vagrant environment containing stentor, Constellation, and the
stentor examples.

### Requirements

  1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  1. Install [Vagrant](https://www.vagrantup.com/downloads.html)

(If you are behind a proxy server, please see https://github.com/jpmorganchase/stentor/issues/23)

### Running

```sh
git clone https://github.com/jpmorganchase/stentor-examples
cd stentor-examples
vagrant up
# (should take 5 or so minutes)
vagrant ssh
```

(*macOS note*: If you get an error saying that the ubuntu/xenial64 image doesn't
exist, please run `sudo rm -r /opt/vagrant/embedded/bin/curl`. This is usually due to
issues with the version of curl bundled with Vagrant.)

Once in the VM environment, `cd stentor-examples` then simply follow the
instructions for the demo you'd like to run.

To shut down the Vagrant instance, run `vagrant suspend`. To delete it, run
`vagrant destroy`. To start from scratch, run `vagrant up` after destroying the
instance.

