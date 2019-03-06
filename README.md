# fabric-weather
Distributed weather station modelled in hyperledger fabric.

<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vSD2ynCXTRIhzSIm0LrA-__1AiRCSmVheJNFeABG_GciVWIj_cGOBsHQS3GF7q85CSFzAbksP98a72l/embed?start=false&loop=false&delayms=3000" frameborder="0" width="960" height="749" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

[Presentation.](https://docs.google.com/presentation/d/1nDtxYk8Xt24zOLACDAJxXDZ_6IYRTzt5nSbsjyqpx3o)

Course project for course "Grid basics and Cloud computing".

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

## Network
Network looks like this:

![Here goes scheme](docs/net.png)

## Usage
This script will bring network up, install chaincode on it's nodes and do testing:
```bash
./weather-network/network_up.sh
```
The output will be:

![Here goes gif](docs/cli_up.gif)

This test code will measure temperature t1 on peer0.north, then measure temperature t2 on peer0.south, then "forecast" average temperature on nodes peer1.north and peer1.south.

To bring network down:
```bash
./weather-network/network_down.sh
```

![Here goes gif 2](docs/cli_down.gif)
