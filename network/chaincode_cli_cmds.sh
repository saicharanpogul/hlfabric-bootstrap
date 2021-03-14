#!/bin/bash
source ../terminal_control.sh


checkCommitReadiness () {
  print Green "========== Check Commit Readiness of Installed Chaincode on Peer0 $ORG_NAME =========="
  echo

  docker exec cli_${ORG_NAME} peer lifecycle chaincode checkcommitreadiness -o localhost:9050 --channelID supplychain-channel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/freight.example.com/orderers/orderer0.freight.example.com/msp/tlscacerts/tlsca.freight.example.com-cert.pem --name supplychain --version 1 --sequence 1 --output json --init-required --signature-policy "AND ('ShipperMSP.peer','FreightMSP.peer','CarrierMSP.peer','CustomMSP.peer','ConsigneeMSP.peer')"

  print Green "========== Check Commit Readiness of Installed Chaincode Successful on Peer0 $ORG_NAME =========="
  echo 
}

commitChaincode () {
  print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} =========="
  echo

  docker exec cli_${ORG_NAME} peer lifecycle chaincode commit \
  -o orderer0.freight.example.com:9050 \
  --ordererTLSHostnameOverride orderer0.freight.example.com \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/freight.example.com/orderers/orderer0.freight.example.com/msp/tlscacerts/tlsca.freight.example.com-cert.pem \
  --channelID supplychain-channel --name supplychain \
  --peerAddresses peer0.shipper.example.com:7051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/shipper.example.com/peers/peer0.shipper.example.com/tls/ca.crt \
  --peerAddresses peer0.freight.example.com:9051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/freight.example.com/peers/peer0.freight.example.com/tls/ca.crt \
  --peerAddresses peer0.carrier.example.com:11051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/carrier.example.com/peers/peer0.carrier.example.com/tls/ca.crt \
  --peerAddresses peer0.custom.example.com:13051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/custom.example.com/peers/peer0.custom.example.com/tls/ca.crt \
  --peerAddresses peer0.consignee.example.com:15051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/consignee.example.com/peers/peer0.consignee.example.com/tls/ca.crt \
  --version 1 --sequence 1 --init-required --signature-policy "AND ('ShipperMSP.peer','FreightMSP.peer','CarrierMSP.peer','CustomMSP.peer','ConsigneeMSP.peer')"

  print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} Successful =========="
  echo
}

initChaincode () {
  print Green "========== Init Chaincode on Peer0 $ORG_NAME ========== "
  echo 

  docker exec cli_${ORG_NAME} peer chaincode invoke \
  -o orderer0.freight.example.com:9050 \
  --ordererTLSHostnameOverride orderer0.freight.example.com \
  --tls true \
  --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/freight.example.com/orderers/orderer0.freight.example.com/msp/tlscacerts/tlsca.freight.example.com-cert.pem \
  -C supplychain-channel -n supplychain \
  --peerAddresses peer0.shipper.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/shipper.example.com/peers/peer0.shipper.example.com/tls/ca.crt \
  --peerAddresses peer0.freight.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/freight.example.com/peers/peer0.freight.example.com/tls/ca.crt \
  --peerAddresses peer0.carrier.example.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/carrier.example.com/peers/peer0.carrier.example.com/tls/ca.crt \
  --peerAddresses peer0.custom.example.com:13051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/custom.example.com/peers/peer0.custom.example.com/tls/ca.crt \
  --peerAddresses peer0.consignee.example.com:15051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/consignee.example.com/peers/peer0.consignee.example.com/tls/ca.crt \
  --isInit -c '{"Args":[]}'

  print Green "========== Init Chaincode on Peer0 $ORG_NAME Successful ========== "
  echo
}

# checkCommitReadiness 
# commitChaincode
initChaincode