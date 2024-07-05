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
CC_SRC_PATH="../artifacts/chaincode/assetContract"
CC_NAME="asset"
CC_POLICY="AND('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer','Org4MSP.peer','Org5MSP.peer','Org6MSP.peer')"

# CC_POLICY="OR('Org1MSP.peer','Org2MSP.peer')"

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


# Initialize Asset contract with asset ID AST0000
chaincodeInitLedgerAsset() {
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
        -c '{"function": "initLedgerAsset","Args":[]}'
}
#Note for version && seuqunce > 1, dont run chaincodeInitLedger as this will reset asset id counter

# chaincodeInitLedgerAsset


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
        -c '{"function": "createAsset", "Args": ["PRJ0001","{\"prj_id\":\"PRJ0001\", \"item_category\":2, \"item_name\":\"ESP system\", \"order_date\":\"1/1/2024\", \"received_date\":\"1/16/2024\", \"installed_date\":\"1/23/2024\", \"item_line_no\":1, \"group\":\"Discharge Head\", \"part_name\":\"Part name\", \"part_desc\":\"ESP MAINS\", \"qty\":1, \"UOM\":\"EA\", \"unit_price\":10000000, \"currency\":\"$\", \"extended_price\":10000000, \"item_status\":2, \"asset_sba_media_list\":[]}"]}'


}

# chaincodeInvoke


chaincodeQueryGetAssetByID() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAsset","Args":["AST0001"]}'
}

# chaincodeQueryGetAssetByID


chaincodeQueryGetAllAssets() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAllAssets","Args":["PRJ0001"]}'
}


# chaincodeQueryGetAllAssets


chaincodeInvokeUpdateAsset() {
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
        -c '{"function": "updateAsset","Args":["AST0002", "{\"item_category\":\"2\", \"item_name\":\"Updated Name\", \"group\":\"Updated Group\", \"part_desc\":\"Updated Description\", \"qty\":\"5\", \"unit_price\":\"10.50\", \"UOM\":\"EA\", \"extended_price\":\"1000\", \"installed_date\":\"2024-02-24\",\"asset_sba_media_list\":[]}"]}'
}

# chaincodeInvokeUpdateAsset



chaincodeQueryGetAssetHistory() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAssetHistory","Args":["AST0001"]}'
}


# chaincodeQueryGetAssetHistory

chaincodeQueryGetLatestAssetID() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getLatestAssetId","Args":[""]}'
}



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
chaincodeInitLedgerAsset
# sleep 3
# chaincodeInvoke
# sleep 3
# chaincodeQueryGetAssetByID
# sleep 3
# chaincodeQueryGetAllAssets
# sleep 3
# chaincodeInvokeUpdateAsset
# sleep 3
# chaincodeQueryGetAssetHistory
# sleep 3
# chaincodeQueryGetLatestAssetID