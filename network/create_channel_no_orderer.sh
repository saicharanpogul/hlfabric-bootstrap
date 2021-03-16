#!/bin/bash
source ../terminal_control.sh

ORG_PORT=`expr $PORT + 1`

ORG_NAME2="freight"
DOMAIN_NAME2="example"
ORG2_PORT="9050"
ORDERER_NUMBER0="0"

ORG_NAME3="carrier"
DOMAIN_NAME3="example"
ORG3_PORT="11050"
ORDERER_NUMBER1="1"

ORG_NAME4="custom"
DOMAIN_NAME4="example"
ORG4_PORT="13050"
ORDERER_NUMBER2="2"

export ORDERER_CA2=${PWD}/organizations/peerOrganizations/$ORG_NAME2.$DOMAIN_NAME2.com/orderers/orderer$ORDERER_NUMBER0.$ORG_NAME2.$DOMAIN_NAME2.com/msp/tlscacerts/tlsca.$ORG_NAME2.$DOMAIN_NAME2.com-cert.pem

export FABRIC_CFG_PATH=${HOME}/fabric/config/
export CORE_PEER_TLS_ENABLED=true


setEnvPeer0() {
  PEER0_PORT=`expr $PORT + 1`
  export PEER0_CA=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID=${ORG_NAME^}MSP
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp
  export CORE_PEER_ADDRESS=localhost:$PEER0_PORT
}

setEnvPeer1() {
  PEER1_PORT=`expr $PORT + 1001`
  export PEER1_CA=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID=${ORG_NAME^}MSP
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp
  export CORE_PEER_ADDRESS=localhost:$PEER1_PORT
}

createChannel() {
  setEnvPeer0
  print Green "========== Creating Channel =========="
  echo

  peer channel create -o 192.168.56.102:$ORG2_PORT -c $CHANNEL_NAME \
  --ordererTLSHostnameOverride orderer$ORDERER_NUMBER0.$ORG_NAME2.$DOMAIN_NAME2.com \
  -f ./channel-artifacts/$CHANNEL_NAME.tx --outputBlock \
  ./channel-artifacts/${CHANNEL_NAME}.block \
  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA2 
  
  print Blue "========== Channel Created =========="
  echo
}

peer0JoinChannel() {
  setEnvPeer0
  print Green "========== Peer0$ORG_NAME Joining Channel '$CHANNEL_NAME' =========="
  echo

  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
  
  print Green "========== Peer0$ORG_NAME Joined Channel '$CHANNEL_NAME' =========="
  echo
}

peer1JoinChannel() {
  setEnvPeer1
  print Green "========== Peer1$ORG_NAME Joining Channel '$CHANNEL_NAME' =========="
  echo

  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
  
  print Green "========== Peer1$ORG_NAME Joined Channel '$CHANNEL_NAME' =========="
  echo
}

anchorPeerUpdate() {
  setEnvPeer0
  print Green "========== Updating Anchor Peer of Peer0$ORG_NAME =========="
  echo

  peer channel update -o 192.168.56.102:$ORG2_PORT --ordererTLSHostnameOverride orderer$ORDERER_NUMBER0.$ORG_NAME2.$DOMAIN_NAME2.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA2
  
  print Green "========== Updated Anchor Peer of Peer0$ORG_NAME =========="
  echo
}

print Yellow "Do you want to create channel?(y/n):"
read channel

if [[ $channel == 'y' ]] 
then
createChannel
fi

print Yellow "For 1 Peer/2 Peers(1/2):"
read NUMBER_OF_PEERS

if [[ $NUMBER_OF_PEERS == 1 ]]
then
peer0JoinChannel
elif [[ $NUMBER_OF_PEERS == 2 ]]
then
peer0JoinChannel
peer1JoinChannel
else
print Red "Invalid Input(either 1/2)."
fi