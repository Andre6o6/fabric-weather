export FABRIC_CFG_PATH=$PWD
export CHANNEL_NAME=weatherbroadcast

if [ ! -d "crypto-config" ]; then
  #Generate crypto/certificate
  ../bin/cryptogen generate --config=./crypto-config.yaml

  #Generating channel artifacts
  ../bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
  ../bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
  ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
  ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

fi

#Bring network up
docker-compose -f docker-compose-cli.yaml up -d

#Prepare channel
docker exec -it cli scripts/channel_up.sh