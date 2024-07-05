"use strict";

const { Contract } = require("fabric-contract-api");
const crypto = require("crypto");

class MyTokenContract extends Contract {
  async initLedgersft(ctx) {
    console.info("ERC 3525 Chaincode Initialization");
  }

  async mint(ctx, walletAddress, slot) {
    const prjVal = await this.fetchProjectValuation(ctx, slot);
    if (!prjVal) {
      throw new Error(
        `Project Valuation for project ID ${slot} does not exist`
      );
    }

    const slotUsed = await this._isSlotUsed(ctx, slot);
    if (slotUsed) {
      throw new Error(
        `Slot ID: ${slot} already minted with Project Valuation ${prjVal}.`
      );
    }

    await this.setPrjVal(ctx, slot, prjVal);

    const tokenId = await this._generateTokenId(ctx);
    const timestamp = new Date(
      ctx.stub.getTxTimestamp().seconds.low * 1000
    ).toISOString();

    const token = {
      docType: "token",
      tokenId,
      minter: walletAddress,
      value: prjVal.toString(),
      slot,
      wallets: [walletAddress],
      timestamp,
      origin: "minted",
    };

    await ctx.stub.putState(tokenId, Buffer.from(JSON.stringify(token)));

    await this.invokeChangeProjectStatus(ctx, slot, "5");
    return JSON.stringify(token);
  }

  async invokeChangeProjectStatus(ctx, prj_id, newStatus) {
    console.info("============= START : Change Project Status ===========");
    const projectContractName = "project";

    const invokeArgs = [
      Buffer.from("changeProjectStatus"),
      Buffer.from(prj_id),
      Buffer.from(newStatus),
    ];

    const response = await ctx.stub.invokeChaincode(
      projectContractName,
      invokeArgs,
      ctx.stub.getChannelID()
    );

    if (response.status !== 200) {
      throw new Error(
        `Failed to invoke changeProjectStatus on Project contract: ${response.message}`
      );
    }
    console.info("============= END : Change Project Status ===========");

    return response.payload.toString(); // Handling the response payload appropriately
  }

  async transferFrom(ctx, tokenId, recipientWalletAddress, valueToTransfer) {
    const tokenAsBytes = await ctx.stub.getState(tokenId);
    if (!tokenAsBytes || tokenAsBytes.length === 0) {
      throw new Error(`Token ${tokenId} does not exist.`);
    }

    let token = JSON.parse(tokenAsBytes.toString());
    const transferValue = parseInt(valueToTransfer);

    if (transferValue > parseInt(token.value)) {
      throw new Error(
        `Transfer value ${transferValue} exceeds the token's balance of ${token.value}.`
      );
    }

    const dynamicKey = `dynamicPrjVal_${token.slot}`;
    let dynamicPrjVal = parseInt(
      (await ctx.stub.getState(dynamicKey)).toString()
    );
    dynamicPrjVal -= transferValue;
    await ctx.stub.putState(dynamicKey, Buffer.from(dynamicPrjVal.toString()));

    const existingTokenId = await this._findTokenForWalletAndSlot(
      ctx,
      recipientWalletAddress,
      token.slot
    );
    if (existingTokenId) {
      const existingTokenAsBytes = await ctx.stub.getState(existingTokenId);
      let existingToken = JSON.parse(existingTokenAsBytes.toString());
      existingToken.value = (
        parseInt(existingToken.value) + transferValue
      ).toString();
      await ctx.stub.putState(
        existingTokenId,
        Buffer.from(JSON.stringify(existingToken))
      );
    } else {
      const newTokenId = await this._generateTokenId(ctx);
      let newToken = {
        docType: "token",
        tokenId: newTokenId,
        minter: token.minter,
        value: transferValue.toString(),
        slot: token.slot,
        wallets: [recipientWalletAddress],
        timestamp: new Date(
          ctx.stub.getTxTimestamp().seconds.low * 1000
        ).toISOString(),
        origin: "transferred",
      };
      await ctx.stub.putState(
        newTokenId,
        Buffer.from(JSON.stringify(newToken))

      );

      await this.invokeChangeProjectStatus(ctx, token.slot, "6");
    }

    token.value = (parseInt(token.value) - transferValue).toString();
    if (parseInt(token.value) === 0) {
      await ctx.stub.deleteState(tokenId); // Optionally delete zero-value tokens
    } else {
      await ctx.stub.putState(tokenId, Buffer.from(JSON.stringify(token)));
    }
  }

  async setPrjVal(ctx, slotId, prjVal) {
    const fixedKey = `fixedPrjVal_${slotId}`;
    const dynamicKey = `dynamicPrjVal_${slotId}`;

    let fixedValueExists = (await ctx.stub.getState(fixedKey)).length > 0;
    let dynamicValueExists = (await ctx.stub.getState(dynamicKey)).length > 0;

    if (!fixedValueExists && !dynamicValueExists) {
      await ctx.stub.putState(fixedKey, Buffer.from(prjVal.toString()));
      await ctx.stub.putState(dynamicKey, Buffer.from(prjVal.toString()));
    } else {
      console.info(
        `Values for slotId ${slotId} already exist. Skipping update.`
      );
    }
  }

  async _generateTokenId(ctx) {
    const currentIdAsBytes = await ctx.stub.getState("currentTokenId");
    let currentId = currentIdAsBytes.toString()
      ? parseInt(currentIdAsBytes.toString())
      : 0;
    currentId++;
    await ctx.stub.putState(
      "currentTokenId",
      Buffer.from(currentId.toString())
    );
    return currentId.toString();
  }

  async _isSlotUsed(ctx, slotId) {
    const results = await this._getQueryResults(
      ctx,
      JSON.stringify({
        selector: {
          docType: "token",
          slot: slotId,
        },
      })
    );
    return results.length > 0;
  }

  async _getQueryResults(ctx, queryString) {
    const resultsIterator = await ctx.stub.getQueryResult(queryString);
    const results = [];
    let response = await resultsIterator.next();
    while (!response.done) {
      if (response.value && response.value.value.toString()) {
        const jsonRes = {
          Key: response.value.key,
          Record: JSON.parse(response.value.value.toString("utf8")),
        };
        results.push(jsonRes);
      }
      response = await resultsIterator.next();
    }
    await resultsIterator.close();
    return results;
  }

  async _findTokenForWalletAndSlot(ctx, walletAddress, slot) {
    let queryString = JSON.stringify({
      selector: {
        docType: "token",
        slot: slot,
        wallets: {
          $in: [walletAddress], // Ensure that the walletAddress is being checked within an array
        },
      },
    });

    const queryResults = await this._getQueryResults(ctx, queryString);
    if (queryResults.length > 0) {
      return queryResults[0].Key; // Return the first matching token's ID
    }
    return null; // If no token found, return null
  }

  async fetchProjectValuation(ctx, prj_id) {
    const projectContractName = "project";
    const channelName = ctx.stub.getChannelID();
    const args = [Buffer.from("getProjectValuation"), Buffer.from(prj_id)];
    const response = await ctx.stub.invokeChaincode(
      projectContractName,
      args,
      channelName
    );
    if (!response || response.status !== 200) {
      throw new Error(
        `Failed to fetch project valuation from Project contract: ${response.message}`
      );
    }
    return response.payload.toString();
  }

  async getAllResults(iterator, isHistory) {
    try {
      let allResults = [];
      while (true) {
        let res = await iterator.next();
        console.log(res.value);

        if (res.value && res.value.value.toString()) {
          let jsonRes = {};
          console.log(res.value.value.toString("utf8"));

          if (isHistory && isHistory === true) {
            jsonRes.txId = res.value.txId;
            jsonRes.Timestamp = res.value.timestamp;
            jsonRes.IsDelete = res.value.is_delete
              ? res.value.is_delete.toString()
              : "false";
            try {
              jsonRes.Value = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              console.log(err);
              jsonRes.Value = res.value.value.toString("utf8");
            }
          } else {
            jsonRes.Key = res.value.key;
            try {
              jsonRes.Record = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              console.log(err);
              jsonRes.Record = res.value.value.toString("utf8");
            }
          }
          allResults.push(jsonRes);
        }
        if (res.done) {
          console.log("end of data");
          await iterator.close();
          console.info("allResults : ", allResults);
          return allResults;
        }
      }
    } catch (err) {
      return new Error(err.message);
    }
  }

  async getNFTHistory(ctx, prj_id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(prj_id);
      let results = await this.getAllResults(resultsIterator, true);
      console.log("results : ", results);

      return results;
    } catch (err) {
      return new Error(err.stack);
    }
  }

  async getLatestTokenId(ctx) {
    const currentIdAsBytes = await ctx.stub.getState("currentTokenId");
    if (!currentIdAsBytes || currentIdAsBytes.length === 0) {
      throw new Error(`No tokens have been minted yet.`);
    }
    const currentId = currentIdAsBytes.toString();
    return currentId;
  }

  async _generate64BitHash(id, uri) {
    const input = `${id}:${uri}`; // Merge id and uri with a separator
    const hash = crypto.createHash("sha256").update(input).digest("hex");
    return hash.substring(0, 16); // Truncate the hash to 64 bits (16 hex characters)
  }

  async setSlotURI(ctx, slotId, slotURI) {
    const key = `slotURI_${slotId}`; // Keep the ID-based key for retrieval
    const hashKey = await this._generate64BitHash(slotId, slotURI); // Generate hash for combined uniqueness or change tracking
    await ctx.stub.putState(
      key,
      Buffer.from(JSON.stringify({ uri: slotURI, hash: hashKey }))
    );
  }

  async getSlotURI(ctx, slotId) {
    const key = `slotURI_${slotId}`;
    const slotURIAsBytes = await ctx.stub.getState(key);
    if (!slotURIAsBytes || slotURIAsBytes.length === 0) {
      throw new Error(`Slot URI for slot ${slotId} does not exist.`);
    }
    const slotURIObject = JSON.parse(slotURIAsBytes.toString());
    return slotURIObject.uri; // Return the URI directly
  }

  async setTokenURI(ctx, tokenId, tokenURI) {
    const key = `tokenURI_${tokenId}`; // Key based on tokenId for easy retrieval
    const hashKey = await this._generate64BitHash(tokenId, tokenURI); // Generate a hash for the combination
    // Store both the URI and the hash for verification
    await ctx.stub.putState(
      key,
      Buffer.from(JSON.stringify({ uri: tokenURI, hash: hashKey }))
    );
  }

  async getTokenURI(ctx, tokenId) {
    const key = `tokenURI_${tokenId}`;
    const tokenURIAsBytes = await ctx.stub.getState(key);
    if (!tokenURIAsBytes || tokenURIAsBytes.length === 0) {
      throw new Error(`Token URI for token ${tokenId} does not exist.`);
    }
    const tokenURIObject = JSON.parse(tokenURIAsBytes.toString());
    return tokenURIObject.uri; // Return the URI directly
  }

  async getRemainingValue(ctx, slotId) {
    const dynamicKey = `dynamicPrjVal_${slotId}`;
    const dynamicPrjValAsBytes = await ctx.stub.getState(dynamicKey);
    if (!dynamicPrjValAsBytes || dynamicPrjValAsBytes.length === 0) {
      throw new Error(
        `Balance of Project Valuation for slot ${slotId} does not exist.`
      );
    }
    return dynamicPrjValAsBytes.toString();
  }

  async cardsInfo(ctx, slotId) {
    let queryString = {
      selector: {
        docType: "token",
        slot: slotId, // Filter tokens by the provided slot ID
      },
    };

    const queryResults = await this._getQueryResults(
      ctx,
      JSON.stringify(queryString)
    );
    return queryResults;
  }

  async getMintedCardsInfo(ctx, slotId) {
    let queryString = JSON.stringify({
      selector: {
        docType: "token",
        slot: slotId,
        origin: "minted",
      },
    });
    const queryResults = await this._getQueryResults(ctx, queryString);
    return queryResults;
  }

  async getTransferredCardsInfo(ctx, slotId) {
    let queryString = JSON.stringify({
      selector: {
        docType: "token",
        slot: slotId,
        origin: "transferred",
      },
    });
    const queryResults = await this._getQueryResults(ctx, queryString);
    return queryResults;
  }
}

module.exports = MyTokenContract;
