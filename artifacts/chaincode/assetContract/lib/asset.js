"use strict";

const { Contract } = require("fabric-contract-api");

class Asset extends Contract {
  //AST0000 (default project ID stored in blockchain ledger if no data)
  async initLedgerAsset(ctx) {
    console.info("Initializing ledger with default lastAssetId 'AST0000'");
    await ctx.stub.putState("lastAssetId", Buffer.from("AST0000"));
    console.info("Ledger initialization complete");
  }

  //helper function to auto-generate ast_id
  async _generateNextAssetId(ctx) {
    const lastIdKey = "lastAssetId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    let lastId = 0;
    if (lastIdData && lastIdData.length > 0) {
      lastId = parseInt(lastIdData.toString().substring(3)) || 0; // Extract the numeric part
    }
    const newIdNumber = lastId + 1;
    const newId = `AST${newIdNumber.toString().padStart(4, "0")}`;
    await ctx.stub.putState(lastIdKey, Buffer.from(newId)); // Store the new lastAssetId
    return newId;
  }

  //save asset details in blockchain ledger
  async createAsset(ctx, prj_id, assetData) {
    try {
      let asset = JSON.parse(assetData);

      // Auto generate field 1 - generating asset id
      const newAssetId = await this._generateNextAssetId(ctx);
      asset.ast_id = newAssetId;

      const timestamp = ctx.stub.getTxTimestamp();
      const tsDate = new Date(timestamp.seconds.low * 1000);
      asset.ast_lastupdate_user = tsDate.toISOString();

      const requiredFields = [
        "item_category",
        "item_name",
        "order_date",
        "received_date",
        "installed_date",
        "item_line_no",
        "group",
        "part_name",
        "part_desc",
        "qty",
        "UOM",
        "unit_price",
        "currency",
        "extended_price",
        "item_status",
        "asset_sba_media_list",
        "ast_lastupdate_user",
      ];

      // Throws error if there is a missing field
      requiredFields.forEach((field) => {
        if (!asset[field]) {
          throw new Error(`Field ${field} is missing`);
        }
      });

      // Assuming order date < received date < installed date
      if (
        new Date(asset.order_date) > new Date(asset.received_date) ||
        new Date(asset.received_date) > new Date(asset.installed_date)
      ) {
        throw new Error("Dates are not in the correct order.");
      }

      // Store the data in the ledger using ast_id as the key
      await ctx.stub.putState(newAssetId, Buffer.from(JSON.stringify(asset)));
      
      await this.invokeChangeProjectStatus(ctx, prj_id, "2");

      return ctx.stub.getTxID();
    } catch (err) {
      throw new Error(err.stack);
    }
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

  //update asset fields
  async updateAsset(ctx, ast_id, updateValue) {
    try {
      const exists = await this.assetExists(ctx, ast_id);
      if (!exists) {
        throw new Error(`The asset with ID ${ast_id} does not exist`);
      }

      // Parse the update value and extract the fields to update
      const updateData = JSON.parse(updateValue);

      // Update timestamp; record the last update time
      const timestamp = ctx.stub.getTxTimestamp();
      const tsDate = new Date(timestamp.seconds.low * 1000);
      updateData.ast_lastupdate_user = tsDate.toISOString(); // Ensuring this field is always updated

      const allowedFields = [
        "item_category",
        "item_name",
        "group",
        "part_desc",
        "qty",
        "unit_price",
        "UOM",
        "extended_price",
        "installed_date",
        "asset_sba_media_list",
        "ast_lastupdate_user", // This field must be in the allowed fields
      ];

      // Validate the received data against the allowed fields
      const invalidFields = Object.keys(updateData).filter(
        (field) => !allowedFields.includes(field)
      );

      if (invalidFields.length > 0) {
        throw new Error(`Invalid fields: ${invalidFields.join(", ")}`);
      }

      // Fetch existing data from the ledger
      const existingData = await ctx.stub.getState(ast_id);
      const currentAsset = JSON.parse(existingData.toString());

      // Merge the existing data with the update data
      const updatedAsset = { ...currentAsset, ...updateData };

      // Update the ledger with the merged data
      await ctx.stub.putState(
        ast_id,
        Buffer.from(JSON.stringify(updatedAsset))
      );

      return ctx.stub.getTxID();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  // gets all assets for particular project ID
  async getAllAssets(ctx, prj_id) {
    try {
      const allResults = [];
      const iterator = await ctx.stub.getStateByRange("", "");
      let result = await iterator.next();

      while (!result.done) {
        const strValue = Buffer.from(result.value.value.toString()).toString(
          "utf8"
        );

        let record;
        try {
          record = JSON.parse(strValue);
        } catch (err) {
          console.log(err);
          record = strValue;
        }

        if (record.prj_id === prj_id) {
          allResults.push({ Key: result.value.key, Record: record });
        }

        result = await iterator.next();
      }

      return JSON.stringify(allResults);
    } catch (err) {
      throw new Error(err.message);
    }
  }

  // gets all details for particular asset ID
  async getAsset(ctx, ast_id) {
    try {
      const assetJSON = await ctx.stub.getState(ast_id);

      if (!assetJSON || assetJSON.length === 0) {
        throw new Error(`The asset with ID ${ast_id} does not exist`);
      }

      return assetJSON.toString();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  //validation function for update
  async assetExists(ctx, ast_id) {
    const assetJSON = await ctx.stub.getState(ast_id);
    return assetJSON && assetJSON.length > 0;
  }

  // helper function for blockchain history
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

  // gets blockchain history for asset id
  async getAssetHistory(ctx, ast_id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(ast_id); // corrected parameter name
      let results = await this.getAllResults(resultsIterator, true); // added the second parameter
      console.log("results : ", results);

      return results;
    } catch (err) {
      throw new Error(err.stack); // changed from returning an Error object to throwing an error
    }
  }

  async getLatestAssetId(ctx) {
    const lastIdKey = "lastAssetId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    if (!lastIdData || lastIdData.length === 0) {
      return "AST0000";
    }
    return lastIdData.toString();
  }
}

module.exports = Asset;
