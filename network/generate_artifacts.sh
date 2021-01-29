#!/bin/bash
source ../terminal_control.sh

export FABRIC_CFG_PATH=${PWD}/configtx
print Blue "$FABRIC_CFG_PATH"

print Purple "System Channel Name: "$SYS_CHANNEL
echo

print Purple "Application Channel Name: "$CHANNEL_NAME
echo

generateGenesisBlock() {
  print Green "========== Generating System Genesis Block =========="
  echo

  ../bin/configtxgen -configPath ./configtx/ -profile OrdererSystemGenesisChannel -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block

  print Green "========== System Genesis Block Generated =========="
  echo
}

generateChannelConfigBlock() {
  print Green "========== Generating Channel Configuration Block =========="
  echo

  ../bin/configtxgen -profile ApplicationChannel -configPath ./configtx/ -outputCreateChannelTx ./channel-artifacts/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME 

  print Green "========== Channel Configuration Block Generated =========="
  echo
}

anchorPeerUpdate() {
  print Green "========== Generating Anchor Peer Update Transaction For ${ORG_NAME}MSP =========="
  echo

  ../bin/configtxgen -profile ApplicationChannel -configPath ./configtx/ -outputAnchorPeersUpdate ./channel-artifacts/${ORG_NAME}MSPAnchor.tx -channelID $CHANNEL_NAME -asOrg ${ORG_NAME}MSP

  print Green "========== Anchor Peer Update For ${ORG_NAME}MSP Transaction Generated =========="
  echo
}

print Yellow "Do you want to generate System Configuration Genesis Block?(y/n):"
read genesis 

if [[ $genesis == 'y' ]]
then
generateGenesisBlock
fi 

print Yellow "Do you want to generate Application Channel Configuration Block?(y/n):"
read application

if [[ $application == 'y' ]]
then
generateChannelConfigBlock
fi

anchorPeerUpdate
