#!/bin/bash
source ../terminal_control.sh

export FABRIC_CFG_PATH=${PWD}/../config/
export ORDERER_CA=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

ORG_PORT=`expr $PORT + 1`

ORG_NAME1="shipper"
DOMAIN_NAME1="example"
ORG1_PORT="7051"

ORG_NAME2="freight"
DOMAIN_NAME2="example"
ORG2_PORT="9051"

ORG_NAME3="carrier"
DOMAIN_NAME3="example"
ORG3_PORT="11051"

ORG_NAME4="custom"
DOMAIN_NAME4="example"
ORG4_PORT="13051"

ORG_NAME5="consignee"
DOMAIN_NAME5="example"
ORG5_PORT="15051"

# Exception
export CORE_PEER_TLS_ROOTCERT_FILE_SHIPPER=/${PWD}/organizations/peerOrganizations/$ORG_NAME1.$DOMAIN_NAME1.com/peers/peer0.$ORG_NAME1.$DOMAIN_NAME1.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_FREIGHT=/${PWD}/organizations/peerOrganizations/$ORG_NAME2.$DOMAIN_NAME2.com/peers/peer0.$ORG_NAME2.$DOMAIN_NAME2.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_CARRIER=/${PWD}/organizations/peerOrganizations/$ORG_NAME3.$DOMAIN_NAME3.com/peers/peer0.$ORG_NAME3.$DOMAIN_NAME3.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_CUSTOM=/${PWD}/organizations/peerOrganizations/$ORG_NAME4.$DOMAIN_NAME4.com/peers/peer0.$ORG_NAME4.$DOMAIN_NAME4.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_CONSIGNEE=/${PWD}/organizations/peerOrganizations/$ORG_NAME5.$DOMAIN_NAME5.com/peers/peer0.$ORG_NAME5.$DOMAIN_NAME5.com/tls/ca.crt

print Blue "Channel Name: $CHANNEL_NAME"

CHAINCODE_NAME="supplychain"
print Blue "Chaincode Name: $CHAINCODE_NAME"

CHAINCODE_VERSION="1"
print Blue "Chaincode Version: $CHAINCODE_VERSION"

CHAINCODE_PATH="../chaincode/supplychain/go/"
CHAINCODE_LABEL="supplychain_1"

setEnv() {
  PEER0_PORT=`expr $PORT + 1`
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID=${ORG_NAME^}MSP
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp
  export CORE_PEER_ADDRESS=localhost:$PEER0_PORT
}

packageChaincode() {
    setEnv
    print Green "========== Packaging Chaincode on Peer0 $ORG_NAME =========="
    echo
    
    peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CHAINCODE_PATH} --lang golang --label ${CHAINCODE_LABEL}
    
    print Green "========== Packaging Chaincode on Peer0 $ORG_NAME Successful =========="
    ls
    echo
}

installChaincode() {
    setEnv
    print Green "========== Installing Chaincode on Peer0 $ORG_NAME =========="
    echo

    peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz --peerAddresses localhost:$ORG_PORT --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}
    
    print Green "========== Installed Chaincode on Peer0 $ORG_NAME =========="
    echo
}

queryInstalledChaincode() {
  setEnv
  print Green "========== Querying Installed Chaincode on Peer0 $ORG_NAME=========="
  echo 

  peer lifecycle chaincode queryinstalled --peerAddresses localhost:$ORG_PORT --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE} > log.txt
  cat log.txt

  print Green "========== Query Installed Chaincode Successful on Peer0 $ORG_NAME=========="
  echo 
}

# for non orderer orgs Change IP
# approveChaincode() {
#   setEnv
#   print Green "========== Approve Installed Chaincode by Peer0 $ORG_NAME =========="
#   echo 

#   PACKAGE_ID=$(sed -n "/${CHAINCODE_LABEL}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
#   print Purple "PackageID is ${PACKAGE_ID}"
#   echo

#   peer lifecycle chaincode approveformyorg -o {IP}:$PORT --ordererTLSHostnameOverride orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com --tls --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --package-id ${PACKAGE_ID}  --init-required --sequence 1 --signature-policy "AND ('${ORG_NAME1^}MSP.peer','${ORG_NAME2^}MSP.peer','${ORG_NAME3^}MSP.peer','${ORG_NAME4^}MSP.peer','${ORG_NAME5^}MSP.peer')"
  
#   print Green "========== Approve Installed Chaincode Successful by Peer0 $ORG_NAME =========="
#   echo
# }

approveChaincode() {
  setEnv
  print Green "========== Approve Installed Chaincode by Peer0 $ORG_NAME =========="
  echo 

  PACKAGE_ID=$(sed -n "/${CHAINCODE_LABEL}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
  print Purple "PackageID is ${PACKAGE_ID}"
  echo

  peer lifecycle chaincode approveformyorg -o localhost:$PORT --ordererTLSHostnameOverride orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com --tls --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --package-id ${PACKAGE_ID}  --init-required --sequence 1 --signature-policy "AND ('${ORG_NAME1^}MSP.peer','${ORG_NAME2^}MSP.peer','${ORG_NAME3^}MSP.peer','${ORG_NAME4^}MSP.peer','${ORG_NAME5^}MSP.peer')"
  
  print Green "========== Approve Installed Chaincode Successful by Peer0 $ORG_NAME =========="
  echo
}

checkCommitReadiness() {
  setEnv
  print Green "========== Check Commit Readiness of Installed Chaincode on Peer0 $ORG_NAME =========="
  echo

  peer lifecycle chaincode checkcommitreadiness -o localhost:9050 --channelID ${CHANNEL_NAME} --tls --cafile ${ORDERER_CA} --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --sequence 1 --output json --init-required --signature-policy "AND ('${ORG_NAME1^}MSP.peer','${ORG_NAME2^}MSP.peer','${ORG_NAME3^}MSP.peer','${ORG_NAME4^}MSP.peer','${ORG_NAME5^}MSP.peer')"

  print Green "========== Check Commit Readiness of Installed Chaincode Successful on Peer0 $ORG_NAME =========="
  echo 
}

# By One Org
commitChaincode() {
  setEnv
  print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} =========="
  echo

  peer lifecycle chaincode commit -o localhost:$PORT --ordererTLSHostnameOverride orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com --tls ${CORE_PEER_TLS_ENABLED} --cafile ${ORDERER_CA} --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_SHIPPER} --peerAddresses localhost:9051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_FREIGHT} --peerAddresses localhost:11051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_CARRIER} --peerAddresses localhost:13051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_CUSTOM} --peerAddresses localhost:15051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_CONSIGNEE} --version ${CHAINCODE_VERSION} --sequence 1 --init-required

  print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} Successful =========="
  echo
}

# By One Org
queryCommittedChaincode() {
  setEnv
  print Green "========== Query Committed Chaincode on ${CHANNEL_NAME} =========="
  echo

  peer lifecycle chaincode querycommitted --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME}
  
  print Green "========== Query Committed Chaincode on ${CHANNEL_NAME} Successful =========="
  echo
}

queryApprovedChaincode() {
  setEnv
  print Green "========== Query Approved of Installed Chaincode on Peer0 $ORG_NAME =========="
  echo

  peer lifecycle chaincode queryapproved -C ${CHANNEL_NAME} -n ${CHAINCODE_NAME} --sequence 1 

  print Green "========== Query Approved of Installed Chaincode on Peer0 $ORG_NAME Successful =========="
  echo
}

# By One Org
initChaincode() {
  setEnv
  print Green "========== Init Chaincode on Peer0 $ORG_NAME ========== "
  echo 

  peer chaincode invoke -o localhost:9050 --ordererTLSHostnameOverride orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com --tls ${CORE_PEER_TLS_ENABLED} --cafile ${ORDERER_CA} -C ${CHANNEL_NAME} -n ${CHAINCODE_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_SHIPPER} --peerAddresses localhost:9051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_FREIGHT} --peerAddresses localhost:11051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_CARRIER} --peerAddresses localhost:13051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_CUSTOM} --peerAddresses localhost:15051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_CONSIGNEE} --isInit -c '{"Args":[]}'
  
  print Green "========== Init Chaincode on Peer0 $ORG_NAME Successful ========== "
  echo
}

# # By all orgs
# installChaincode #2
# queryInstalledChaincode #3
# approveChaincode #4
# checkCommitReadiness #5

# # By One Org
# packageChaincode #1
# commitChaincode #6
# queryCommittedChaincode #7
# queryApprovedChaincode #8
# initChaincode #9


packageChaincode #1
installChaincode #2
queryInstalledChaincode #3
approveChaincode #4
checkCommitReadiness #5
commitChaincode #6
queryCommittedChaincode #7
queryApprovedChaincode #8
initChaincode #9