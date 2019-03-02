# fabric-weather
Distributed weather station modelled in hyperledger fabric

## Pre-requisite
Prerequisites for Hyperledger Fabric:
* cURL
* Docker
* Docker-compose
* Go

Download Binaries and Docker Images for Hyperledger Fabric using script:
```bash
./scripts/bootstrap.sh
```
(honestly, might not work so consider cloning [this repo](https://github.com/hyperledger/fabric-samples) and moving *weather-network* and *chaincode* there)

## Usage
Network looks like this:

![Here goes scheme](/docs/net.png)

This script will bring network up, install chaincode on it's nodes and do testing:
```bash
cd weather-network
./network_up.sh
```
The output will be:

![Here goes gif](/docs/cli_up.gif)

To bring network down:
```bash
./network_down.sh
```

![Here goes gif 2](/docs/cli_down.gif)
