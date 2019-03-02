export CHANNEL_NAME=weatherbroadcast

echo "Instantiating chaincode..."
peer chaincode instantiate -o orderer.meteo.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/meteo.com/orderers/orderer.meteo.com/msp/tlscacerts/tlsca.meteo.com-cert.pem -C $CHANNEL_NAME -n w6cc -v 1.0 -c '{"Args":["init","t1", "0", "t2","0"]}'
echo "t1, t2 are set to zero."
echo "North and south weather probes are ready for measurement"

sleep 5

echo "Try measure t1:"
peer chaincode invoke -o orderer.meteo.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/meteo.com/orderers/orderer.meteo.com/msp/tlscacerts/tlsca.meteo.com-cert.pem -C $CHANNEL_NAME -n w6cc --peerAddresses peer0.north.meteo.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/north.meteo.com/peers/peer0.north.meteo.com/tls/ca.crt -c '{"Args":["measure","t1","10"]}'

sleep 5

peer chaincode query -C $CHANNEL_NAME -n w6cc -c '{"Args":["query","t1"]}'

sleep 5

echo "Try measure t2:"
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/users/Admin@south.meteo.com/msp CORE_PEER_ADDRESS=peer0.south.meteo.com:9051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/peers/peer0.south.meteo.com/tls/ca.crt peer chaincode invoke -o orderer.meteo.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/meteo.com/orderers/orderer.meteo.com/msp/tlscacerts/tlsca.meteo.com-cert.pem -C $CHANNEL_NAME -n w6cc --peerAddresses peer0.south.meteo.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/peers/peer0.south.meteo.com/tls/ca.crt -c '{"Args":["measure","t2","15"]}'

sleep 5

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/users/Admin@south.meteo.com/msp CORE_PEER_ADDRESS=peer0.south.meteo.com:9051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/peers/peer0.south.meteo.com/tls/ca.crt peer chaincode query -C $CHANNEL_NAME -n w6cc -c '{"Args":["query","t2"]}'

sleep 5

echo "Try forecasting on peer1.north:"
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/north.meteo.com/users/Admin@north.meteo.com/msp CORE_PEER_ADDRESS=peer1.north.meteo.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/north.meteo.com/peers/peer1.north.meteo.com/tls/ca.crt peer chaincode invoke -o orderer.meteo.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/meteo.com/orderers/orderer.meteo.com/msp/tlscacerts/tlsca.meteo.com-cert.pem -C $CHANNEL_NAME -n w6cc --peerAddresses peer1.north.meteo.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/north.meteo.com/peers/peer1.north.meteo.com/tls/ca.crt -c '{"Args":["forecast","t1","t2"]}'

echo "Try forecasting on peer1.south:"
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/users/Admin@south.meteo.com/msp CORE_PEER_ADDRESS=peer1.south.meteo.com:10051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/peers/peer1.south.meteo.com/tls/ca.crt peer chaincode invoke -o orderer.meteo.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/meteo.com/orderers/orderer.meteo.com/msp/tlscacerts/tlsca.meteo.com-cert.pem -C $CHANNEL_NAME -n w6cc --peerAddresses peer1.south.meteo.com:10051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/south.meteo.com/peers/peer1.south.meteo.com/tls/ca.crt -c '{"Args":["forecast","t1","t2"]}'