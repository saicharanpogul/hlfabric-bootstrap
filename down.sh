#!/bin/bash
source ./terminal_control.sh

print Yellow '(1 - CA / 2 - Peer/Orderer/CouchDB/CLI)'
read option

if [ $option == 1 ]
then
pushd ./network/docker/
print Green '========== Removing CA Containers =========='
docker-compose -f docker-compose-ca-$ORG_NAME.yaml down -v
print Green '========== Removed CA Containers =========='
popd
elif [ $option == 2 ]
then
pushd ./network/docker/
print Green '========== Removing Peer/Orderer/CouchDB/CLI Containers =========='
docker-compose -f docker-compose-$ORG_NAME.yaml down -v
print Green '========== Removed Peer/Orderer/CouchDB/CLI Containers =========='
popd
else
print Red 'Invalid Input'
fi