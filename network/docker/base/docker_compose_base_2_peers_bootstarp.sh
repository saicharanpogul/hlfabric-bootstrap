#!/bin/bash
source ../../../terminal_control.sh

ORG_MSP="${ORG_NAME^}MSP"
ORDERER_PORT=$PORT

PEER0_PORT=`expr $ORDERER_PORT + 1`
PEER0_CHAINCODE_PORT=`expr $PEER0_PORT + 1`
PEER1_PORT=`expr $PEER0_PORT + 1000`
PEER1_CHAINCODE_PORT=`expr $PEER1_PORT + 1`
print Blue "Peer0_Port: $PEER0_PORT | Peer0_Chaincode_Port: $PEER0_CHAINCODE_PORT"
print Blue "Peer1_Port: $PEER1_PORT | Peer1_Chaincode_Port: $PEER1_CHAINCODE_PORT"

echo "version: '2'

services: 

  orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com:
    environment: 
      - ORDERER_GENERAL_LISTENPORT=$ORDERER_PORT
      - ORDERER_GENERAL_LOCALMSPID=$ORG_MSP
    extends: 
      file: peer-base.yaml
      service: orderer-base
    volumes: 
      - ../../channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/:/var/hyperledger/orderer/msp
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/:/var/hyperledger/orderer/tls
      - orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com:/var/hyperledger/production/orderer
    ports: 
      - $ORDERER_PORT:$ORDERER_PORT
      - 8443:8443

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
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer1.$ORG_NAME.$DOMAIN_NAME.com:$PEER1_PORT
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.$ORG_NAME.$DOMAIN_NAME.com:$PEER0_PORT
      - CORE_PEER_LOCALMSPID=$ORG_MSP
    volumes: 
      - /var/run/:/host/var/run/
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp:/etc/hyperledger/fabric/msp
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls:/etc/hyperledger/fabric/tls
      - peer0.$ORG_NAME.$DOMAIN_NAME.com:/var/hyperledger/production
    ports: 
      - $PEER0_PORT:$PEER0_PORT

  peer1.$ORG_NAME.$DOMAIN_NAME.com:
    container_name: peer1.$ORG_NAME.$DOMAIN_NAME.com
    extends: 
      file: peer-base.yaml
      service: peer-base
    environment: 
      - CORE_PEER_ID=peer1.$ORG_NAME.$DOMAIN_NAME.com
      - CORE_PEER_ADDRESS=peer1.$ORG_NAME.$DOMAIN_NAME.com:$PEER1_PORT
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER1_PORT
      - CORE_PEER_CHAINCODEADDRESS=peer1.$ORG_NAME.$DOMAIN_NAME.com:$PEER1_CHAINCODE_PORT
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:$PEER1_CHAINCODE_PORT
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.$ORG_NAME.$DOMAIN_NAME.com:$PEER0_PORT
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.$ORG_NAME.$DOMAIN_NAME.com:$PEER1_PORT
      - CORE_PEER_LOCALMSPID=$ORG_MSP
    volumes: 
      - /var/run/:/host/var/run/
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/msp:/etc/hyperledger/fabric/msp
      - ../../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls:/etc/hyperledger/fabric/tls
      - peer1.$ORG_NAME.$DOMAIN_NAME.com:/var/hyperledger/production
    ports: 
      - $PEER1_PORT:$PEER1_PORT" > docker-compose-base-$ORG_NAME.yaml

print Green "docker-compose-base-$ORG_NAME.yaml"