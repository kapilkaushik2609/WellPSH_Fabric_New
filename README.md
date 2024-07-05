Wells PSH Fabric Network

Overview

HIAM, or the Hitachi Industrial Assets Monetization System, serves as a comprehensive platform designed to streamline the aggregation, management, and monetization of assets for all stakeholders involved. It offers a sophisticated avenue to effectively oversee assets, identify performance trends, analyze lifecycle patterns, and extract valuable insights from the amassed data. Within HIAM, Power Storage Hydroelectricity (PSH) emerges as a specialized subset, exclusively dedicated to the meticulous management of assets associated with oil well-based hydroelectricity. 

PSH within HIAM provides a tailored solution for optimizing operations and maximizing returns on investment in this specific sector.


Power Storage Hydroelectricity (PSH) represents a specialized application focused on meticulously tracking, monitoring, and analyzing the key assets and their performance within a novel solution. This solution entails the generation of electricity from the kinetic energy of falling water within oil wells during the extraction process. The energy harnessed through this innovative method serves to power the operations and processing needs of the asset owner. Moreover, any surplus energy produced is seamlessly transmitted to microgrids, thereby contributing to a significant reduction in the carbon footprint of the entire ecosystem

This project sets up a Hyperledger Fabric network for managing assets through two channels: AssetMonetizationChannel and AssetOperationsChannel. It utilizes IPFS for storage hashing and incorporates both ERC-3525 and ERC-20 token standards.

Architecture

    Channels: 2 (AssetMonetizationChannel, AssetOperationsChannel)
    Organizations: 6
    Endorsing Peers: 1 per organization
    Smart Contracts: 4 (Project, Asset, Valuations, Proposal, erc3525 Semi Fungible Token, erc20 Fungible Token)
    External Dependencies:
        IPFS server for file hashing

Prerequisites

    Docker and Docker-Compose
    Node.js and npm
    Hyperledger Fabric binaries
    PM2 (npm install -g pm2)

Directory Structure

~/WellsPSHFabric/
│
├── artifacts/
│ ├── channel/ # Channel artifacts and scripts
│ └── docker-compose.yaml # Docker-compose file for network
│
├── scripts/ # Scripts for network management
│ ├── healthCheck.sh
│ ├── createChannel.sh
│ ├── createChannel2.sh
│ ├── deployProject.sh
│ ├── deployAsset.sh
│ ├── deployValuations.sh
│ ├── deployProposal.sh
│ ├── deploy_erc3525.sh
│ └── deploy_erc20.sh
│
└── api-2.0/ # Node.js API
├── app.js
├── config/
│ └── generate-ccp.sh # Script to generate connection profiles
└── package.json

Setup Instructions

1. Generate Artifacts and Network Configuration

Navigate to the create-artifacts-with-ca directory and start the necessary Docker containers:

cd ~/artifacts/channel/create-artifacts-with-ca/
docker-compose up -d
./create-artifacts-with-ca.sh
cd ../..

Generate the remaining network artifacts:

cd ~/artifacts/channel/
./create-artifacts.sh
cd ../..

Bring up the network:

cd ~/artifacts/
docker-compose up -d
cd ..

2. Deploy and Initialize Channels

Execute the scripts to set up the channels and deploy contracts:

cd ~/scripts/
./healthCheck.sh
./createChanne.sh # For AssetMonetizationChannel
./createChannel2.sh # For AssetOperationsChannel
./deployProject.sh
./deployAsset.sh
./deployValuations.sh
./deployProposal.sh
./deploy_erc3525.sh
./deploy_erc20.sh
cd ..

3. Configure and Start API Server

Set up the API server to interact with the blockchain network:

cd ~/api-2.0/
cd config/
./generate-ccp.sh
cd ..
pm2 start app.js

Usage

This API allows clients to interact with the Hyperledger Fabric network to register users, manage assets, and query chaincode states through secured endpoints. Below are the endpoints provided by the API along with required parameters and usage examples.
Health Check

    GET /api/health
        Description: Checks the health of the Hyperledger network.
        Response: Returns operational status of the network.

User Management

    POST /users
        Description: Registers and enrolls a user with the network.

POST /register

    Description: Similar to /users, but intended for different client handling.

POST /users/login

    Description: Authenticates a user and returns a JWT token.

Chaincode Interaction
Invocations

    POST /channels/{channelName}/chaincodes/{chaincodeName}
        Description: Submits a transaction to the specified chaincode and channel.
        Parameters:
            channelName: Name of the channel
            chaincodeName: Name of the chaincode

Given the detailed server code you provided, here’s how you can structure the Usage section of your README to properly guide users on how to interact with the API endpoints defined in your Hyperledger Fabric project.
Usage

This API allows clients to interact with the Hyperledger Fabric network to register users, manage assets, and query chaincode states through secured endpoints. Below are the endpoints provided by the API along with required parameters and usage examples.
Health Check

    GET /api/health
        Description: Checks the health of the Hyperledger network.
        Response: Returns operational status of the network.

User Management

    POST /users
        Description: Registers and enrolls a user with the network.
        Body:

        json

    {
      "username": "john_doe",
      "orgName": "Org1"
    }

    Response: JWT token for authentication with further requests.

POST /register

    Description: Similar to /users, but intended for different client handling.
    Body:

    json

    {
      "username": "john_doe",
      "orgName": "Org1"
    }

    Response: JWT token and additional registration details.

POST /users/login

    Description: Authenticates a user and returns a JWT token.
    Body:

    json

        {
          "username": "john_doe",
          "password": "12345"
        }

        Response: JWT token to be used with Bearer authentication scheme for protected endpoints.

Chaincode Interaction
Invocations

    POST /channels/{channelName}/chaincodes/{chaincodeName}
        Description: Submits a transaction to the specified chaincode and channel.
        Parameters:
            channelName: Name of the channel
            chaincodeName: Name of the chaincode
        Body:

        json

        {
          "fcn": "createAsset",
          "args": ["asset1", "value1", "owner1"],
          "peers": ["peer0.org1.example.com", "peer0.org2.example.com"]
        }

        Response: Result of the chaincode execution or an error message.

Queries

    GET /channels/{channelName}/chaincodes/{chaincodeName}
        Description: Queries the specified chaincode and channel.
        Parameters:
            channelName: Name of the channel
            chaincodeName: Name of the chaincode
        Query:
            fcn: Chaincode function to be invoked
            args: Arguments for the chaincode function, as a JSON array in string format
        Example URL: /channels/mychannel/chaincodes/mycc?fcn=queryAsset&args=["asset1"]
        Response: Output of the chaincode query or an error message.