. envVar.sh
. utils.sh

# nvm -0.39.7, node -v16.20.2, npm -8.19.4
presetup() {
    echo Installing npm packages ...
    pushd ../artifacts/chaincode/javascript
    npm install
    popd
    echo Finished installing npm dependencies
}

# presetup


CHANNEL_NAME="channel1"
CC_RUNTIME_LANGUAGE="node"
VERSION="1"
SEQUENCE=1
CC_SRC_PATH="../artifacts/chaincode/proposalContract"
CC_NAME="proposal"
# CC_POLICY="OR('Org1MSP.peer','Org2MSP.peer')"
CC_POLICY="AND('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer','Org4MSP.peer','Org5MSP.peer','Org6MSP.peer')"



packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobals 1
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged ===================== "
}

# packageChaincode


installChaincode() {
    setGlobals 1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org1 ===================== "

    setGlobals 2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org2 ===================== "

    setGlobals 3
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org3 ===================== "

    setGlobals 4
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org4 ===================== "

    setGlobals 5
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org5 ===================== "

    setGlobals 6
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org6 ===================== "
}

# installChaincode


queryInstalled1() {
    setGlobals 1
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled1


queryInstalled2() {
    setGlobals 2
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled2


queryInstalled3() {
    setGlobals 3
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled3


queryInstalled4() {
    setGlobals 4
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled4


queryInstalled5() {
    setGlobals 5
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled5


queryInstalled6() {
    setGlobals 6
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled6


approveForMyOrg1() {
    setGlobals 1
    set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal --tls \
        --signature-policy ${CC_POLICY} \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}
    set +x

    echo "===================== chaincode approved from Org1 ===================== "
}

# approveForMyOrg1


checkCommitReadyness() {
    setGlobals 1
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --signature-policy ${CC_POLICY} \
        --sequence ${SEQUENCE} --output json
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness


approveForMyOrg2() {
    setGlobals 2

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal --tls $CORE_PEER_TLS_ENABLED \
        --signature-policy ${CC_POLICY} \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 2 ===================== "
}

# approveForMyOrg2


approveForMyOrg3() {
    setGlobals 3

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal --tls $CORE_PEER_TLS_ENABLED \
        --signature-policy ${CC_POLICY} \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 3 ===================== "
}

# approveForMyOrg3


approveForMyOrg4() {
    setGlobals 4

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal --tls $CORE_PEER_TLS_ENABLED \
        --signature-policy ${CC_POLICY} \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 4 ===================== "
}

# approveForMyOrg4


approveForMyOrg5() {
    setGlobals 5

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal --tls $CORE_PEER_TLS_ENABLED \
        --signature-policy ${CC_POLICY} \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 5 ===================== "
}

# approveForMyOrg5


approveForMyOrg6() {
    setGlobals 6

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal --tls $CORE_PEER_TLS_ENABLED \
        --signature-policy ${CC_POLICY} \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 6 ===================== "
}

# approveForMyOrg6


checkCommitReadyness() {

    setGlobals 1
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --signature-policy ${CC_POLICY} \
        --name ${CC_NAME} --version ${VERSION} --sequence ${SEQUENCE} --output json
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness


commitChaincodeDefination() {
    setGlobals 1
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.hiam.hal \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --signature-policy ${CC_POLICY} \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA \
        --peerAddresses localhost:17051 --tlsRootCertFiles $PEER0_ORG6_CA \
        --version ${VERSION} --sequence ${SEQUENCE}
}

# commitChaincodeDefination


queryCommitted1() {
    setGlobals 1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

# queryCommitted1


queryCommitted2() {
    setGlobals 2
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

# queryCommitted2


queryCommitted3() {
    setGlobals 3
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

# queryCommitted3


queryCommitted4() {
    setGlobals 4
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

# queryCommitted4


queryCommitted5() {
    setGlobals 5
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

# queryCommitted5


queryCommitted6() {
    setGlobals 6
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

# queryCommitted6


# Initialize Proposal contract with asset ID PRO0000
chaincodeInitLedgerProposal() {
    setGlobals 1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA   \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA   \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA   \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA   \
        --peerAddresses localhost:17051 --tlsRootCertFiles $PEER0_ORG6_CA   \
        -c '{"function": "initLedgerProposal","Args":[]}'
}
#Note for version && seuqunce > 1, dont run chaincodeInitLedgerProposal as this will reset proposal id counter


chaincodeInvoke() {
    setGlobals 1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA \
        --peerAddresses localhost:17051 --tlsRootCertFiles $PEER0_ORG6_CA \
        -c '{"function": "createProposal", "Args": ["PRJ0001", "{\"prj_id\":\"PRJ0001\", \"proposal_date\":\"2024-05-01\", \"proposal_doc_ref\":\"ipfs://bafybeigdyrzt5sfp7udm7hu76uh7yirfbnxsyfydp4s6iyyd2se3pjq3m\", \"tot_prj_val\":2500000, \"Proposal_summary\":\"Innovative proposal for a sustainable energy project aiming to reduce carbon footprint by 40% over the next 5 years.\"}"]}'
}

# chaincodeInvoke


chaincodeUpdate() {
    setGlobals 1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.hiam.hal \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA \
        --peerAddresses localhost:17051 --tlsRootCertFiles $PEER0_ORG6_CA \
        -c '{"function":"updateProposal", "Args":["PROP0001","{\"tot_prj_val\":3000000, \"Proposal_summary\":\"Updated: Expanding the scope to include new innovative solar panel technology.\"}"]}'
}

# chaincodeUpdate


chaincodeQueryGetProposalByID() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getProposal","Args":["PROP0001"]}'
}

# chaincodeQueryGetValuationByID


chaincodeQueryGetAllProposal() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAllProposalsForProject","Args":["PRJ0001"]}'
}

# chaincodeQueryGetAllValuation


chaincodeQueryGetProposalHistory() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getProposalHistory","Args":["PROP0001"]}'
}

# chaincodeQueryGetValuationHistory


chaincodeQueryLatestPROPID() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getLatestProposalId","Args":[""]}'
}

# chaincodeQueryLatestValID




##########################################################################################################################################################

# presetup

packageChaincode
installChaincode
queryInstalled1
queryInstalled2
queryInstalled3
queryInstalled4
queryInstalled5
queryInstalled6
approveForMyOrg1
checkCommitReadyness
approveForMyOrg2
approveForMyOrg3
approveForMyOrg4
approveForMyOrg5
approveForMyOrg6
checkCommitReadyness
commitChaincodeDefination
queryCommitted1
queryCommitted2
queryCommitted3
queryCommitted4
queryCommitted5
queryCommitted6
sleep 3
chaincodeInitLedgerProposal
# sleep 3
# chaincodeInvoke
# sleep 3
# chaincodeUpdate
# sleep 3
# chaincodeQueryGetProposalByID
# sleep 3
# chaincodeQueryGetAllProposal
# sleep 3
# chaincodeQueryLatestPROPID
# sleep 3
# chaincodeQueryGetProposalHistory