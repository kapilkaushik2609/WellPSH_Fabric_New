const { Gateway, Wallets } = require("fabric-network");
const fs = require("fs");
const path = require("path");
const log4js = require("log4js");
const logger = log4js.getLogger("BasicNetwork");
const util = require("util");

const helper = require("./helper");
const query = async (
  channelName,
  chaincodeName,
  args,
  fcn,
  username,
  org_name
) => {
  try {
    console.log("are we here?-query");
    const ccp = await helper.getCCP(org_name);

    const walletPath = await helper.getWalletPath(org_name);
    const wallet = await Wallets.newFileSystemWallet(walletPath);
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

    const gateway = new Gateway();
    await gateway.connect(ccp, {
      wallet,
      identity: username,
      discovery: { enabled: true, asLocalhost: true },
    });

    const network = await gateway.getNetwork(channelName);
    const contract = network.getContract(chaincodeName);
    let result;

    fcn = JSON.parse(fcn);

    if (
      fcn == "getAllProjects" ||
      fcn == "getAllProjectMedia" ||
      fcn == "getAllTokenIds" ||
      fcn == "getTokenCounter" ||
      fcn == "getLatestTokenId"
    ) {
      result = await contract.evaluateTransaction(fcn);
    } else if (
      fcn == "getLatestProjectId" ||
      fcn == "getLatestAssetId" ||
      fcn == "getLatestValuationId" ||
      fcn == "getLatestProposalId"
    ) {
      console.log(fcn);
      result = await contract.evaluateTransaction(fcn);
      return result.toString();
    } else if (
      fcn == "getProject" ||
      fcn == "cardsInfo" ||
      fcn == "getValuation" ||
      fcn == "getProposal" ||
      fcn == "getAllValuationsForProject" ||
      fcn == "getAllProposalsForProject" ||
      fcn == "getValHistory" ||
      fcn == "getProposalHistory"
    ) {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getProject" || fcn == "cardsInfo") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getAsset") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getAllAssets") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getAssetHistory") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getProjectHistory") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getTokenURI") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getSlotURI") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getRemainingValue") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getProjectStatus") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getPrjVal") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "getNFTHistory") {
      result = await contract.evaluateTransaction(fcn, args[0]);
    } else if (fcn == "CheckNetworkStatus") {
      result = await contract.evaluateTransaction(fcn);
    }

    console.log("result", result);
    console.log(
      `Transaction has been evaluated, result is: ${result.toString()}`
    );

    result = JSON.parse(result.toString());
    return result;
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    return error.message;
  }
};

exports.query = query;
