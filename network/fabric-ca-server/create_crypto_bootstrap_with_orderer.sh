#!/bin/bash
source ../../terminal_control.sh

generateCrypto() {

  CA_PORT=`expr $PORT + 4`
  echo
  echo "Enroll CA Admin for $ORG_NAME"
  echo

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/

  fabric-ca-client enroll -u https://${ORG_NAME}:adminpw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo "NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: orderer" >${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Register peer0.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register peer1.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register orderer0.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name orderer0 --id.secret orderer0pw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register user1.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register admin.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name $ORG_NAME --id.secret adminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers

  # Peer0

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate Peer0 MSP"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts peer0.$ORG_NAME.$DOMAIN_NAME.com --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate Peer0 TLS-Certs"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts peer0.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  # Just for anchor Peer0?

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/tlsca

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/tlsca/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/ca

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/ca/ca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  # Peer1

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate Peer1 MSP"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts peer1.$ORG_NAME.$DOMAIN_NAME.com --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate Peer1 TLS-Certs"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts peer1.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  #  Orderer0

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate the Orderer0 MSP"
  echo

  fabric-ca-client enroll -u https://orderer0:orderer0pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts $ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate the orderer0 TLS-Certs"
  echo

  fabric-ca-client enroll -u https://orderer0:orderer0pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts $ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  #mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  echo
  print Green "Certificates are generated!"
  echo
}

generateCrypto


# if [ "$#" -ne 3 ]; then
#   print Red "3 Arguments Expected"
#   echo
#   print Red "Arg1 = Organization Name(without space between) | Arg2 = Domain Name(without '.com') | Arg3 = Port Number(eg. 7054, 8054, etc)"
#   exit 1
# else 
#   ORG=$1
#   DOMAIN=$2
#   PORT=$3
#   generateCrypto
# fi