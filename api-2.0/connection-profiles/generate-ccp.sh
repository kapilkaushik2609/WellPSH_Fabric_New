#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/org1.hiam.hal/peers/peer0.org1.hiam.hal/tls/tlscacerts/tls-localhost-7054-ca-org1-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/org1.hiam.hal/msp/tlscacerts/ca.crt

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-org1.json

# ORG=2
# P0PORT=9051
# CAPORT=8054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/org2.hiam.hal/peers/peer0.org2.hiam.hal/tls/tlscacerts/tls-localhost-8054-ca-org2-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/org2.hiam.hal/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-org2.json


# ORG=3
# P0PORT=11051
# CAPORT=9054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/org3.hiam.hal/peers/peer0.org3.hiam.hal/tls/tlscacerts/tls-localhost-9054-ca-org3-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/org3.hiam.hal/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-org3.json

# ORG=4
# P0PORT=13051
# CAPORT=10054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/org4.hiam.hal/peers/peer0.org4.hiam.hal/tls/tlscacerts/tls-localhost-10054-ca-org4-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/org4.hiam.hal/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-org4.json

# ORG=5
# P0PORT=15051
# CAPORT=11054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/org5.hiam.hal/peers/peer0.org5.hiam.hal/tls/tlscacerts/tls-localhost-11054-ca-org5-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/org5.hiam.hal/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-org5.json

# ORG=6
# P0PORT=17051
# CAPORT=12054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/org6.hiam.hal/peers/peer0.org6.hiam.hal/tls/tlscacerts/tls-localhost-12054-ca-org6-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/org6.hiam.hal/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-org6.json
