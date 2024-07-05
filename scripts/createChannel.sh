#!/bin/bash

# imports  
. envVar.sh
. utils.sh

#channel1 = asset monetization channel
CHANNEL_NAME='channel1'

createChannel(){
    setGlobals 1
    osnadmin channel join --channelID $CHANNEL_NAME \
    --config-block ../channel-artifacts/${CHANNEL_NAME}.block -o localhost:7053 \
    --ca-file $ORDERER_CA \
    --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT \
    --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY 

    setGlobals 1
    osnadmin channel join --channelID $CHANNEL_NAME \
    --config-block ../channel-artifacts/${CHANNEL_NAME}.block -o localhost:8053 \
    --ca-file $ORDERER_CA \
    --client-cert $ORDERER2_ADMIN_TLS_SIGN_CERT \
    --client-key $ORDERER2_ADMIN_TLS_PRIVATE_KEY 

    setGlobals 1
    osnadmin channel join --channelID $CHANNEL_NAME \
    --config-block ../channel-artifacts/${CHANNEL_NAME}.block -o localhost:9053 \
    --ca-file $ORDERER_CA \
    --client-cert $ORDERER3_ADMIN_TLS_SIGN_CERT \
    --client-key $ORDERER3_ADMIN_TLS_PRIVATE_KEY 

}

createChannel

sleep 3


#all 6 orgs join channel1
joinChannel(){
    sleep 2
    FABRIC_CFG_PATH=$PWD/../artifacts/channel/config
    setGlobals 1
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

    sleep 2
    
    setGlobals 2
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

    sleep 2
    
    setGlobals 3
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block
    
    sleep 2
    
    setGlobals 4
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

    sleep 2
    
    setGlobals 5
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

    sleep 2
    
    setGlobals 6
    peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block
        
}

joinChannel


