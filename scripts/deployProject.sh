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

# prestup

CHANNEL_NAME="channel1"
CC_RUNTIME_LANGUAGE="node"
VERSION="1"
SEQUENCE=1
CC_SRC_PATH="../artifacts/chaincode/projectContract"
CC_NAME="project"
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

# queryInstalled


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

#Hello Project smartcontract, also resets project ID to prj0000
chaincodeInitLedger() {
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
        -c '{"function": "initLedger","Args":[]}'
}
#Note for version && seuqunce > 1, dont run chaincodeInitLedger as this will reset project id counter
# chaincodeInitLedger

# prj_id is autogenerated
chaincodeInvoke() {
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
        -c '{"function": "createProject","Args":["{\"prj_name\":\"projectA\",\"prj_company\":\"Green Planet Money LLC\",\"prj_company_details\":\"Address1,Address2, City, TX-12345,USA\",\"prj_description\":\"The Nearby Well is located near Great Lake TX. The Disposal Well was built in 1970. Water is disposed into San Andreas from 5000 feet. The project has assets installed and ready for generating green electricity during SWD disposal using PSH. The main KPI for the project is MW of electricity produced and sold/consumed internally. It has potential to earn Carbon Credits that are redeemable in the Carbon Exchange Markets.\",\"prj_sba_id\":\"PRJ001A0001\",\"prj_sba_address\":\"Great Lake, Oil Land, TX, USA\",\"prj_sba_landmark\":\"2.5 miles East of Great Lake, TX\",\"prj_sba_lat\":30.123456,\"prj_sba_long\":-100.123177,\"prj_sba_details\":\"Continuous SWD available from nearby Oil Wells. There is potential to improve revenue\",\"prj_sba_media_list\":\"<url=url of uploaded photo>,<type=photo>,<file-hash>\",\"asset_services_list\":\"<PRJ0001A0002>,<PRJ0001A0003>,<PRJ0001A0004>,<PRJ0001S0001>\",\"prj_nft_id\":\"3525\",\"prj_valuation\":1230000,\"prj_start_date\":\"2024-01-01T00:00:00.000Z\",\"prj_end_date\":\"2024-02-02T00:00:00.000Z\"}"]}'

}

# Note - Mandatory fields are validated, extra fields are ignored, 2 fields - prj_id and prj_lastupdate_user which is a timestamp are auto generated
# chaincodeInvoke

chaincodeUpdate() {
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
        -c '{"function":"updateProject","Args":["PRJ0001","{\"prj_company\":\"RED Planet Money LLC\",\"prj_company_details\":\"Address3,Address4, City, NY-54321,USA\"}"]}'
}

# Note- fields to be updated is dynamic, all data comes in the form of one json object
# chaincodeUpdate

chaincodeChangeProjectStatus() {
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
        -c '{"function":"changeProjectStatus","Args":["PRJ0001","2"]}'
}



chaincodeQueryallKeys() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAllProjects","Args":[]}'
}

# chaincodeQueryallKeys


chaincodeQuerybyKey() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getProject","Args":["PRJ0001"]}'
}

# chaincodeQuerybyKey

chaincodeProjectHistory() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getProjectHistory","Args":["PRJ0001"]}'
}

# chaincodeProjectHistory

chaincodeProjectStatus() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getProjectStatus","Args":["PRJ0001"]}'
}

# chaincodeProjectHistory

getLatestProjectId() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getLatestProjectId","Args":[""]}'
}

# getLatestProjectId


chaincodeQueryProjectValuation() {
    setGlobals 1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getProjectValuation","Args":["PRJ0001"]}'
}

# chaincodeQueryProjectValuation

#############################################################################################################################################################3

# prestup

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
queryCommitted1pm2
queryCommitted2
queryCommitted3
queryCommitted4
queryCommitted5
queryCommitted6
sleep 3
chaincodeInitLedger
# sleep 3
# chaincodeInvoke
# sleep 3
# chaincodeUpdate
# sleep 3
# chaincodeQueryallKeys
# sleep 3
# chaincodeQuerybyKey
# sleep 3
# chaincodeProjectHistory
# sleep 3
# chaincodeProjectStatus
# sleep 3
# getLatestProjectId
# sleep 3
# chaincodeChangeProjectStatus
# sleep 3
# chaincodeQueryProjectValuation