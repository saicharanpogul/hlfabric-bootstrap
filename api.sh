#!/bin/bash
source ./terminal_control.sh


print Yellow '(1 - Start Client / 2 - Stop Client / 3 - Down Client)'
read option


if [ $option == 1 ]
then
pushd ./api/
print Green '========== Starting Client Containers =========='
docker-compose up -d
print Green '========== Started Client Containers =========='
popd
elif [ $option == 2 ]
then
pushd ./api/
print Green '========== Stoping Client Containers =========='
docker-compose stop
print Green '========== Stoped Client Containers =========='
popd
elif [ $option == 3 ]
then
pushd ./api/
print Green '========== Tearing Down Client Containers =========='
docker-compose down -v
print Green '========== Teared Down Client Containers =========='
popd
else
print Red "Invalid Input"
fi