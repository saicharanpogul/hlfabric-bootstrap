#!/bin/bash
source ../../terminal_control.sh

ORG_PORT=`expr $PORT + 1`

echo "version: '2'

volumes: 
  orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com:
  peer0.$ORG_NAME.$DOMAIN_NAME.com:
  peer1.$ORG_NAME.$DOMAIN_NAME.com:

networks: 
  $NETWORK:
      external: 
        name: $NETWORK

services: 

  orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com:
    extends: 
      file: base/docker-compose-base-$ORG_NAME.yaml
      service: orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com
    container_name: orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com
    networks: 
      - $NETWORK

  $ORG_NAME.couchdb1:
    container_name: $ORG_NAME.couchdb1
    image: couchdb:3.1.1
    environment: 
      - COUCHDB_USER=$ORG_NAME
      - COUCHDB_PASSWORD=adminpw
    ports: 
      - 5984:5984
    networks: 
      - $NETWORK

  peer0.$ORG_NAME.$DOMAIN_NAME.com:
    extends: 
      file: base/docker-compose-base-$ORG_NAME.yaml
      service: peer0.$ORG_NAME.$DOMAIN_NAME.com
    environment: 
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=$ORG_NAME.couchdb1:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$ORG_NAME
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=adminpw
    depends_on: 
      - $ORG_NAME.couchdb1
    networks: 
      - $NETWORK

  $ORG_NAME.couchdb2:
    container_name: $ORG_NAME.couchdb2
    image: couchdb:3.1.1
    environment: 
      - COUCHDB_USER=$ORG_NAME
      - COUCHDB_PASSWORD=adminpw
    ports: 
      - 6984:5984
    networks: 
      - $NETWORK

  peer1.$ORG_NAME.$DOMAIN_NAME.com:
    extends: 
      file: base/docker-compose-base-$ORG_NAME.yaml
      service: peer1.$ORG_NAME.$DOMAIN_NAME.com
    environment: 
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=$ORG_NAME.couchdb2:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$ORG_NAME
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=adminpw
    depends_on: 
      - $ORG_NAME.couchdb2
    networks: 
      - $NETWORK

  cli:
    container_name: cli_${ORG_NAME}
    image: hyperledger/fabric-tools:\$IMAGE_TAG
    tty: true
    stdin_open: true 
    environment: 
      - SYS_CHANNEL=${SYS_CHANNEL}
      - GOPATH=/opt/gopath
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_ID=cli_${ORG_NAME}
      - CORE_PEER_ADDRESS=peer0.${ORG_NAME}.${DOMAIN_NAME}.com:$ORG_PORT
      - CORE_PEER_LOCALMSPID=${ORG_NAME^}MSP
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME}.${DOMAIN_NAME}.com/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME}.${DOMAIN_NAME}.com/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME}.${DOMAIN_NAME}.com/tls/ca.crt
      - CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME}.${DOMAIN_NAME}.com/users/Admin@${ORG_NAME}.${DOMAIN_NAME}.com/msp
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: /bin/bash
    volumes: 
        - /var/run/:/host/var/run/
        - ../organizations:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/
        - ../channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts
    depends_on: 
      - orderer${ORDERER_NUMBER}.${ORG_NAME}.${DOMAIN_NAME}.com
      - peer0.${ORG_NAME}.${DOMAIN_NAME}.com
      - peer1.${ORG_NAME}.${DOMAIN_NAME}.com
    networks: 
      - $NETWORK" > docker-compose-${ORG_NAME}.yaml

print Green "docker-compose-$ORG_NAME.yaml"