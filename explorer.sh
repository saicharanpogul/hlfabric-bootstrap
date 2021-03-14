#!/bin/bash
source ./terminal_control.sh


print Yellow '(1 - Start Explorer / 2 - Stop Explorer / 3 - Down Explorer)'
read option


if [ $option == 1 ]
then
pushd ./explorer/
print Green '========== Starting Explorer Containers =========='
docker-compose up -d
print Green '========== Started Explorer Containers =========='
popd
elif [ $option == 2 ]
then
pushd ./explorer/
print Green '========== Stoping Explorer Containers =========='
docker-compose stop
print Green '========== Stoped Explorer Containers =========='
popd
elif [ $option == 3 ]
then
pushd ./explorer/
print Green '========== Tearing Down Explorer Containers =========='
docker-compose down -v
print Green '========== Teared Down Explorer Containers =========='
popd
else
print Red "Invalid Input"
fi