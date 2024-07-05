#!/bin/bash

# channel name defaults to "channel1 which is asset monetization channel"
CHANNEL_NAME="channel1"

echo $CHANNEL_NAME

# Generate Channel Genesis block
configtxgen -profile SixOrgsApplicationGenesis -configPath . -channelID $CHANNEL_NAME  -outputBlock ../../channel-artifacts/$CHANNEL_NAME.block

sleep 1

# channel name defaults to "channel2 which is asset operations channel"
CHANNEL_NAME="channel2"

echo $CHANNEL_NAME

# Generate Channel Genesis block
configtxgen -profile FourOrgsApplicationGenesis -configPath . -channelID $CHANNEL_NAME  -outputBlock ../../channel-artifacts/$CHANNEL_NAME.block

