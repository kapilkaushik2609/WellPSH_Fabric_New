. envVar.sh
. utils.sh

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
CC_SRC_PATH="../artifacts/chaincode/erc3525Contract"
CC_NAME="pshsft"
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

    echo "===================== chaincode approved from org 1 ===================== "

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


chaincodeInvokeInitLedger3525() {
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
        -c '{"function":"initLedgersft","Args":[]}'
}

# chaincodeInvokeInitLedger3525


chaincodeMint() {
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
        -c '{"function":"mint","Args":["https://org1admin:org1adminpw@localhost:7054", "PRJ0001"]}'
}

# chaincodeMint



chaincodeTransfer() {
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
        -c '{"function":"transferFrom","Args":["1", "https://org3admin:org3adminpw@localhost:9054", "40"]}'
}

# chaincodeTransfer


chaincodeQueryGetNFTHistory() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getNFTHistory","Args":["1"]}'
}

# chaincodeQueryGetNFTHistory


chaincodeQueryTokenID() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getLatestTokenId","Args":[]}'
}

# chaincodeQueryTokenID


chaincodeQueryGetRemainingValue() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getRemainingValue","Args":["PRJ0001"]}'
}

# chaincodeQueryGetRemainingValue



chaincodeQueryTransferredCards() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getTransferredCardsInfo","Args":["PRJ0001"]}'
}

# chaincodeQueryTransferredCards


chaincodeQueryMintedCards() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getMintedCardsInfo","Args":["PRJ0001"]}'
}

# chaincodeQueryMintedCards

chaincodeQueryAllCardsInfo() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "cardsInfo","Args":["PRJ0001"]}'
}

# chaincodeQueryAllCardsInfo

chaincodeInvokeSetSlotURI() {
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
        -c '{"function":"setSlotURI","Args":["PRJ0001", "{\"aa\":\"bbb\"}"]}'
}

# chaincodeInvokeSetSlotURI


chaincodeQueryGetSlotURIByID() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getSlotURI","Args":["PRJ0001"]}'
}

# chaincodeQueryGetSlotURIByID



chaincodeInvokeSetTokenURI() {
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
        -c '{"function":"setTokenURI","Args":["1", "{\"ax\":\"bx\"}"]}'
}

# chaincodeInvokeSetTokenURI


chaincodeQueryTokenURI() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getTokenURI","Args":["1"]}'
}


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
chaincodeInvokeInitLedger3525

# sleep 1
# chaincodeMint
# sleep 3
# chaincodeTransfer

# sleep 1
# chaincodeQueryGetNFTHistory
# sleep 1
# chaincodeQueryTokenID
# sleep 1
# chaincodeQueryGetRemainingValue
# sleep 1
# chaincodeQueryTransferredCards
# sleep 1
# chaincodeQueryMintedCards
# sleep 1
# chaincodeQueryAllCardsInfo

# sleep 3 
# chaincodeInvokeSetSlotURI
# sleep 3
# chaincodeQueryGetSlotURIByID
# sleep 3
# chaincodeInvokeSetTokenURI
# sleep 3
# chaincodeQueryTokenURI




# sleep 3
# chaincodeInvokeSetPrjValuation
# sleep 3
# chaincodeQueryPrjVal
# sleep 3 
# chaincodeMint
# sleep 3
# chaincodeQueryGetRemainingValue
# sleep 3
# chaincodeTransfer
# sleep 3 
# chaincodeInvokeSetSlotURI
# sleep 3
# chaincodeQueryGetSlotURIByID
# sleep 3
# chaincodeInvokeSetTokenURI
# sleep 3
# chaincodeQueryTokenURI
# sleep 3
# chaincodeQueryTokenID






    

