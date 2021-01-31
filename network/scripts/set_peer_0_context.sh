#!/bin/bash
source ../../terminal_control.sh

PEER0_PORT=`expr $PORT + 1`
export FABRIC_CFG_PATH=$PWD/../../config/

export CORE_PEER_LOCALMSPID="${ORG_NAME^}MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp
export CORE_PEER_ADDRESS=localhost:$PEER0_PORT