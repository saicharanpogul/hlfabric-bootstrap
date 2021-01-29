#!/bin/bash
source ../../terminal_control.sh

echo "version: '2'

volumes: 
  orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com
  peer0.$ORG_NAME.$DOMAIN_NAME.com
  peer1.$ORG_NAME.$DOMAIN_NAME.com

networks: 
  $NETWORK:

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
      - $NETWORK" > docker-compose-${ORG_NAME}.yaml

print Green "docker-compose-$ORG_NAME.yaml"