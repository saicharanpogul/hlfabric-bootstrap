#!/bin/bash
source ../../../terminal_control.sh

ORG_MSP="${ORG_NAME^}MSP"

PEER0_PORT=`expr $PORT + 1`
PEER0_CHAINCODE_PORT=`expr $PEER0_PORT + 1`
print Blue "Peer0_Port: $PEER0_PORT | Peer0_Chaincode_Port: $PEER0_CHAINCODE_PORT"

echo "version: '2'

services: 

  peer0.$ORG_NAME.$DOMAIN_NAME.com:
    container_name: peer0.$ORG_NAME.$DOMAIN_NAME.com
    extends: 
      file: peer-base.yaml
      service: peer-base
    environment: 
      - CORE_PEER_ID=peer0.$ORG_NAME.$DOMAIN_NAME.com
      - CORE_PEER_ADDRESS=peer0.$ORG_NAME.$DOMAIN_NAME.com:$PEER0_PORT
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER0_PORT
      - CORE_PEER_CHAINCODEADDRESS=peer0.$ORG_NAME.$DOMAIN_NAME.com:$PEER0_CHAINCODE_PORT
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:$PEER0_CHAINCODE_PORT
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.$ORG_NAME.$DOMAIN_NAME.com:$PEER0_PORT
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.$ORG_NAME.$DOMAIN_NAME.com:$PEER0_PORT
      - CORE_PEER_LOCALMSPID=$ORG_MSP
    volumes: 
      - /var/run/:/host/var/run/
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp:/etc/hyperledger/fabric/msp
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls:/etc/hyperledger/fabric/tls
      - peer0.$ORG_NAME.$DOMAIN_NAME.com:/var/hyperledger/production
    ports: 
      - $PEER0_PORT:$PEER0_PORT" > docker-compose-base-$ORG_NAME.yaml

print Green "docker-compose-base-$ORG_NAME.yaml"