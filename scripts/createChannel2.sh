#!/bin/bash

# imports  
. envVar2.sh
. utils.sh


#channel 2 =  asset operations channel
CHANNEL_NAME2='channel2'

createChannel2(){
    setGlobals 1
    osnadmin channel join --channelID $CHANNEL_NAME2 \
    --config-block ../channel-artifacts/${CHANNEL_NAME2}.block -o localhost:7053 \
    --ca-file $ORDERER_CA \
    --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT \
    --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY 

    setGlobals 1
    osnadmin channel join --channelID $CHANNEL_NAME2 \
    --config-block ../channel-artifacts/${CHANNEL_NAME2}.block -o localhost:8053 \
    --ca-file $ORDERER_CA \
    --client-cert $ORDERER2_ADMIN_TLS_SIGN_CERT \
    --client-key $ORDERER2_ADMIN_TLS_PRIVATE_KEY 

    setGlobals 1
    osnadmin channel join --channelID $CHANNEL_NAME2 \
    --config-block ../channel-artifacts/${CHANNEL_NAME2}.block -o localhost:9053 \
    --ca-file $ORDERER_CA \
    --client-cert $ORDERER3_ADMIN_TLS_SIGN_CERT \
    --client-key $ORDERER3_ADMIN_TLS_PRIVATE_KEY 

}

createChannel2

#4 orgs join channel2 - [Org1- wells psh company | Org3- Asset/Service Owner (SC Partners) | Org4- PSH Electric Customer | Org6- Auditor/Regulator (CO2 )]
joinChannel2(){
    sleep 2
    FABRIC_CFG_PATH=$PWD/../artifacts/channel/config

    setGlobals 1
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME2}.block

    sleep 2
    
    setGlobals 3
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME2}.block

    sleep 2
    
    setGlobals 4
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME2}.block

    sleep 2

    setGlobals 6
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME2}.block
        
}

joinChannel2