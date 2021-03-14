#!/bin/bash
source ../../terminal_control.sh

PEER1_PORT=`expr $PORT + 1001`
export FABRIC_CFG_PATH=$PWD/../../config/

export CORE_PEER_LOCALMSPID="${ORG_NAME^}MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp
export CORE_PEER_ADDRESS=localhost:$PEER1_PORT

export CORE_PEER_TLS_ROOTCERT_FILE_SHIPPER=/${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_FREIGHT=/${PWD}/organizations/peerOrganizations/$ORG_NAME2.$DOMAIN_NAME2.com/peers/peer0.$ORG_NAME2.$DOMAIN_NAME2.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_CARRIER=/${PWD}/organizations/peerOrganizations/$ORG_NAME3.$DOMAIN_NAME3.com/peers/peer0.$ORG_NAME3.$DOMAIN_NAME3.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_CUSTOM=/${PWD}/organizations/peerOrganizations/$ORG_NAME4.$DOMAIN_NAME4.com/peers/peer0.$ORG_NAME4.$DOMAIN_NAME4.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_CONSIGNEE=/${PWD}/organizations/peerOrganizations/$ORG_NAME5.$DOMAIN_NAME5.com/peers/peer0.$ORG_NAME5.$DOMAIN_NAME5.com/tls/ca.crt