const {
  Gateway,
  Wallets,
  TxEventHandler,
  GatewayOptions,
  DefaultEventHandlerStrategies,
  TxEventHandlerFactory,
} = require("fabric-network");
const fs = require("fs");
const path = require("path");
const log4js = require("log4js");
const logger = log4js.getLogger("BasicNetwork");
const util = require("util");
let resultJSON;

const helper = require("./helper");

const invokeTransaction = async (
  channelName,
  chaincodeName,
  fcn,
  args,
  username,
  org_name,
  transientData
) => {
  try {
    logger.debug(
      util.format(
        "\n============ invoke transaction on channel %s ============\n",
        channelName
      )
    );
    const ccp = await helper.getCCP(org_name);
    const walletPath = await helper.getWalletPath(org_name);
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    console.log("start");
    console.log(ccp);
    console.log(walletPath);
    console.log(wallet);
    console.log("end");
    console.log(`Wallet path: ${walletPath}`);

    let identity = await wallet.get(username);
    if (!identity) {
      console.log(
        `An identity for the user ${username} does not exist in the wallet, so registering user`
      );
      await helper.getRegisteredUser(username, org_name, true);
      identity = await wallet.get(username);
      console.log("Run the registerUser.js application before retrying");
      return;
    }

    const connectOptions = {
      wallet,
      identity: username,
      discovery: { enabled: true, asLocalhost: true },
      eventHandlerOptions: {
        commitTimeout: 100,
        strategy: DefaultEventHandlerStrategies.NETWORK_SCOPE_ALLFORTX,
      },
    };

    const gateway = new Gateway();
    await gateway.connect(ccp, connectOptions);

    const network = await gateway.getNetwork(channelName);

    const contract = network.getContract(chaincodeName);

    let result;
    let message;
    if (fcn === "createProject") {
      result = await contract.submitTransaction(fcn, args);
      message = `Successfully added data `;
    } else if (fcn == "updateProject") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully updated data `;
    } else if (fcn == "createAsset") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully added data `;
    } else if (fcn == "updateAsset") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully updated data `;
    } else if (fcn == "createValuation") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully added Valuation Data `;
    } else if (fcn == "updateValuation") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully updated Valuation Data `;
    } else if (fcn == "createProposal") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully added Proposal Data `;
    } else if (fcn == "updateProposal") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully updated Proposal Data `;
    }
    else if (fcn == "setPrjVal") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
      message = `Successfully updated data `;
    }
    else if (fcn == 'transferFrom') {
      const resultBuffer = await contract.submitTransaction(fcn, args[0], args[1], args[2]);
      const resultString = resultBuffer.toString(); // Convert Buffer to string
      //  resultJSON = JSON.parse(resultString); // Parse the string as JSON
      console.log("resulat json", resultString);
      message = `Successfully Transfered value: ${args[2]}`;
      // Use resultJSON as needed
    }
    else if (fcn == 'mint') {
      const resultBuffer = await contract.submitTransaction(fcn, args[0], args[1]);
      const resultString = resultBuffer.toString(); // Convert Buffer to string
       resultJSON = JSON.parse(resultString); // Parse the string as JSON
      console.log("resulat json", resultJSON);
      message = `Successful Minted for ${args[1]}`;
      // Use resultJSON as needed
    }
    else if(fcn == "setSlotURI") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
    }
    else if(fcn == "setTokenURI") {
      result = await contract.submitTransaction(fcn, args[0], args[1]);
    }
    else {
      return `Invocation require either createProject , createProjectMedia, updateProject as function but got ${fcn}`;
    }

    await gateway.disconnect();

    let response = {
      message: message,
      result,
      resultJSON
    };

    return response;
  } catch (error) {
    console.log(`Getting error: ${error}`);
    return error.message;
  }
};

exports.invokeTransaction = invokeTransaction;
