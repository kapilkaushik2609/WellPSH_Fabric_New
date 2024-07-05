createcertificatesForOrg1() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/org1.hiam.hal/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.org1.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-hiam-hal.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-hiam-hal.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-hiam-hal.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-hiam-hal.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.org1.hiam.hal --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.org1.hiam.hal --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.org1.hiam.hal --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/org1.hiam.hal/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/msp --csr.hosts peer0.org1.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls --enrollment.profile tls --csr.hosts peer0.org1.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/tlsca/tlsca.org1.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/ca/ca.org1.hiam.hal-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/org1.hiam.hal/users
  mkdir -p ../crypto-config/peerOrganizations/org1.hiam.hal/users/User1@org1.hiam.hal

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.org1.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/User1@org1.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/User1@org1.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/User1@org1.hiam.hal/msp/keystore/priv_sk
  mkdir -p ../crypto-config/peerOrganizations/org1.hiam.hal/users/Admin@org1.hiam.hal

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca.org1.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/Admin@org1.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/Admin@org1.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/Admin@org1.hiam.hal/msp/keystore/priv_sk
  cp ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.hiam.hal/users/Admin@org1.hiam.hal/msp/config.yaml

}

createCertificatesForOrg2() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/org2.hiam.hal/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.org2.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-hiam-hal.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-hiam-hal.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-hiam-hal.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-hiam-hal.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org2.hiam.hal --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org2.hiam.hal --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org2.hiam.hal --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org2.hiam.hal/peers
  mkdir -p ../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.org2.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/msp --csr.hosts peer0.org2.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.org2.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls --enrollment.profile tls --csr.hosts peer0.org2.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/tlsca/tlsca.org2.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/ca/ca.org2.hiam.hal-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/org2.hiam.hal/users
  mkdir -p ../crypto-config/peerOrganizations/org2.hiam.hal/users/User1@org2.hiam.hal

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.org2.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/User1@org2.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/User1@org2.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/User1@org2.hiam.hal/msp/keystore/priv_sk

  mkdir -p ../crypto-config/peerOrganizations/org2.hiam.hal/users/Admin@org2.hiam.hal

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca.org2.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/Admin@org2.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/Admin@org2.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/Admin@org2.hiam.hal/msp/keystore/priv_sk

  cp ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org2.hiam.hal/users/Admin@org2.hiam.hal/msp/config.yaml

}

createCertificatesForOrg3() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/org3.hiam.hal/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca.org3.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-hiam-hal.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-hiam-hal.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-hiam-hal.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-org3-hiam-hal.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org3.hiam.hal --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org3.hiam.hal --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org3.hiam.hal --id.name org3admin --id.secret org3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org3.hiam.hal/peers
  mkdir -p ../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.org3.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/msp --csr.hosts peer0.org3.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.org3.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls --enrollment.profile tls --csr.hosts peer0.org3.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/tlsca/tlsca.org3.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/ca/ca.org3.hiam.hal-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/org3.hiam.hal/users
  mkdir -p ../crypto-config/peerOrganizations/org3.hiam.hal/users/User1@org3.hiam.hal

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca.org3.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/User1@org3.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/User1@org3.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/User1@org3.hiam.hal/msp/keystore/priv_sk

  mkdir -p ../crypto-config/peerOrganizations/org3.hiam.hal/users/Admin@org3.hiam.hal

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org3admin:org3adminpw@localhost:9054 --caname ca.org3.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/Admin@org3.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/Admin@org3.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/Admin@org3.hiam.hal/msp/keystore/priv_sk

  cp ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org3.hiam.hal/users/Admin@org3.hiam.hal/msp/config.yaml

}

createCertificatesForOrg4() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/org4.hiam.hal/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.org4.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org4-hiam-hal.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org4-hiam-hal.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org4-hiam-hal.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org4-hiam-hal.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org4.hiam.hal --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org4.hiam.hal --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org4.hiam.hal --id.name org4admin --id.secret org4adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org4.hiam.hal/peers
  mkdir -p ../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.org4.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/msp --csr.hosts peer0.org4.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.org4.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls --enrollment.profile tls --csr.hosts peer0.org4.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/tlsca/tlsca.org4.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/ca/ca.org4.hiam.hal-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/org4.hiam.hal/users
  mkdir -p ../crypto-config/peerOrganizations/org4.hiam.hal/users/User1@org4.hiam.hal

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.org4.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/User1@org4.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/User1@org4.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/User1@org4.hiam.hal/msp/keystore/priv_sk

  mkdir -p ../crypto-config/peerOrganizations/org4.hiam.hal/users/Admin@org4.hiam.hal

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org4admin:org4adminpw@localhost:10054 --caname ca.org4.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/Admin@org4.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org4/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/Admin@org4.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/Admin@org4.hiam.hal/msp/keystore/priv_sk

  cp ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org4.hiam.hal/users/Admin@org4.hiam.hal/msp/config.yaml

}

createCertificatesForOrg5() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/org5.hiam.hal/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca.org5.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org5-hiam-hal.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org5-hiam-hal.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org5-hiam-hal.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org5-hiam-hal.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org5.hiam.hal --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org5.hiam.hal --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org5.hiam.hal --id.name org5admin --id.secret org5adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org5.hiam.hal/peers
  mkdir -p ../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca.org5.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/msp --csr.hosts peer0.org5.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca.org5.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls --enrollment.profile tls --csr.hosts peer0.org5.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/tlsca/tlsca.org5.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/ca/ca.org5.hiam.hal-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/org5.hiam.hal/users
  mkdir -p ../crypto-config/peerOrganizations/org5.hiam.hal/users/User1@org5.hiam.hal

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca.org5.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/User1@org5.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/User1@org5.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/User1@org5.hiam.hal/msp/keystore/priv_sk

  mkdir -p ../crypto-config/peerOrganizations/org5.hiam.hal/users/Admin@org5.hiam.hal

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org5admin:org5adminpw@localhost:11054 --caname ca.org5.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/Admin@org5.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org5/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/Admin@org5.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/Admin@org5.hiam.hal/msp/keystore/priv_sk

  cp ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org5.hiam.hal/users/Admin@org5.hiam.hal/msp/config.yaml

}

createCertificatesForOrg6() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/org6.hiam.hal/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:12054 --caname ca.org6.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-org6-hiam-hal.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-org6-hiam-hal.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-org6-hiam-hal.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-org6-hiam-hal.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.org6.hiam.hal --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.org6.hiam.hal --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.org6.hiam.hal --id.name org6admin --id.secret org6adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/org6.hiam.hal/peers
  mkdir -p ../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca.org6.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/msp --csr.hosts peer0.org6.hiam.hal --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca.org6.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls --enrollment.profile tls --csr.hosts peer0.org6.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/tlsca/tlsca.org6.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/ca/ca.org6.hiam.hal-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/org6.hiam.hal/users
  mkdir -p ../crypto-config/peerOrganizations/org6.hiam.hal/users/User1@org6.hiam.hal

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:12054 --caname ca.org6.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/User1@org6.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/User1@org6.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/User1@org6.hiam.hal/msp/keystore/priv_sk

  mkdir -p ../crypto-config/peerOrganizations/org6.hiam.hal/users/Admin@org6.hiam.hal

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org6admin:org6adminpw@localhost:12054 --caname ca.org6.hiam.hal -M ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/Admin@org6.hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/org6/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/Admin@org6.hiam.hal/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/Admin@org6.hiam.hal/msp/keystore/priv_sk

  cp ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org6.hiam.hal/users/Admin@org6.hiam.hal/msp/config.yaml

}

createCretificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/hiam.hal

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:13054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/orderers/hiam.hal

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/msp --csr.hosts orderer.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls --enrollment.profile tls --csr.hosts orderer.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/msp/tlscacerts/tlsca.hiam.hal-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/tlscacerts/tlsca.hiam.hal-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/msp --csr.hosts orderer2.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls --enrollment.profile tls --csr.hosts orderer2.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/msp/tlscacerts/tlsca.hiam.hal-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer2.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/tlscacerts/tlsca.hiam.hal-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/msp --csr.hosts orderer3.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls --enrollment.profile tls --csr.hosts orderer3.hiam.hal --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/msp/tlscacerts/tlsca.hiam.hal-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/orderers/orderer3.hiam.hal/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/tlscacerts/tlsca.hiam.hal-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/users
  mkdir -p ../crypto-config/ordererOrganizations/hiam.hal/users/Admin@hiam.hal

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:13054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/users/Admin@hiam.hal/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/hiam.hal/users/Admin@hiam.hal/msp/config.yaml

}

# createCretificateForOrderer

removeOldCredentials() {
  # sudo rm -rf ../../../../api-2.x/wallets/*
  sudo rm -rf ../crypto-config/*

}

createConnectionProfile() {
  cd ../../../../api/connection-profiles && ./generate-ccp.sh

}

# removeOldCredentials
createcertificatesForOrg1
sleep 1
createCertificatesForOrg2
sleep 1
createCertificatesForOrg3
sleep 1
createCertificatesForOrg4
sleep 1
createCertificatesForOrg5
sleep 1
createCertificatesForOrg6
sleep 1
createCretificatesForOrderer

# createConnectionProfile

