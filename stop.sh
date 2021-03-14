#!/bin/bash
source ./terminal_control.sh

print Yellow '(1 - CA / 2 - Peer/Orderer/CouchDB/CLI)'
read option

if [ $option == 1 ]
then
pushd ./network/docker/
print Green '========== Stopping CA Containers =========='
docker-compose -f docker-compose-ca-$ORG_NAME.yaml stop
print Green '========== Stopped CA Containers =========='
popd
elif [ $option == 2 ]
then
pushd ./network/docker/
print Green '========== Stopping Peer/Orderer/CouchDB/CLI Containers =========='
docker-compose -f docker-compose-$ORG_NAME.yaml stop
print Green '========== Stopped Peer/Orderer/CouchDB/CLI Containers =========='
popd
else
print Red 'Invalid Input'
fi