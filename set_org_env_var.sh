#!/bin/bash
source ./terminal_control.sh

print Yellow "Enter Network Name:"
read NETWORK

print Yellow "Enter Organization Name(without space):"
read ORG_NAME

print Yellow "Enter $ORG_NAME Domain Name(without '.com'):"
read DOMAIN_NAME

print Yellow "Enter $ORG_NAME Orderer Number(starts from 0 to ..):"
read ORDERER_NUMBER

print Yellow "Enter Port Number for $ORG_NAME(eg. 7050):"
read PORT

print Yellow "Enter System Channel Name"
read SYS_CHANNEL

print Yellow "Enter Channel Name:"
read CHANNEL_NAME

print Purple "
Network Name: $NETWORK
Organization Name: $ORG_NAME
Domain Name: $DOMAIN_NAME
Orderer Number: $ORDERER_NUMBER
Port: $PORT
Channel Name: $CHANNEL_NAME
System Channel Name: $SYS_CHANNEL
"

echo "

export NETWORK=$NETWORK
export ORG_NAME=$ORG_NAME
export DOMAIN_NAME=$DOMAIN_NAME
export ORDERER_NUMBER=$ORDERER_NUMBER
export PORT=$PORT
export CHANNEL_NAME=$CHANNEL_NAME
export SYS_CHANNEL=$SYS_CHANNEL" >> ~/.bashrc