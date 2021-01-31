#!/bin/bash
source ../../terminal_control.sh

function peer() {

PORT_NO=`expr $PORT + 4`
IMAGE_VERSION='$IMAGE_TAG'
PORTS="${PORT_NO}:${PORT_NO}"

echo "version: '2'

networks: 
  ${NETWORK}:

services: 
  
  ca_${ORG_NAME}:
    image: hyperledger/fabric-ca:${IMAGE_VERSION}
    environment: 
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca.${ORG_NAME}.${DOMAIN_NAME}.com
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT=${PORT_NO}
    ports: 
      - \"${PORTS}\"
    command: sh -c 'fabric-ca-server start -b ${ORG_NAME}:adminpw -d'
    volumes: 
      - ../organizations/fabric-ca/${ORG_NAME}:/etc/hyperledger/fabric-ca-server
    container_name: ca_${ORG_NAME}
    networks: 
      - ${NETWORK}
" > docker-compose-ca-${ORG_NAME}.yaml

print Green "docker-compose-ca-${ORG_NAME}.yaml is ready"
}

function orderer() {

PORT_NO=`expr $PORT + 4`
IMAGE_VERSION='$IMAGE_TAG'
PORTS="${PORT_NO}:${PORT_NO}"

echo "version: '2'

networks: 
  ${NETWORK}:
      external: 
      name: ${NETWORK}

services: 
  
  ca_orderer:
    image: hyperledger/fabric-ca:${IMAGE_VERSION}
    environment: 
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-orderer
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_PORT=${PORT_NO}
    ports: 
      - \"${PORTS}\"
    command: sh -c 'fabric-ca-server start -b ${ORG_NAME}:adminpw -d'
    volumes: 
      - ../organizations/fabric-ca/ordererOrg:/etc/hyperledger/fabric-ca-server
    container_name: ca_orderer
    networks: 
      - ${NETWORK}
" > docker-compose-ca-orderer.yaml

print Green "docker-compose-ca-orderer.yaml is ready"
}

print Yellow "CA for Peer or Orderer? (accepted input peer/orderer)"
read input
if [ $input = 'peer' ]
then
peer
elif [ $input = 'orderer' ]
then
orderer
else
print Red "Invalid Input. [It should be either peer/orderer]"
exit 1
fi