"use strict";

const { Contract } = require("fabric-contract-api");

class Valuation extends Contract {
  async initLedgerValuation(ctx) {
    console.info("Initializing ledger with default lastValuationId 'VAL0000'");
    await ctx.stub.putState("lastValuationId", Buffer.from("VAL0000"));
    console.info("Ledger initialization complete");
  }

  async _generateNextValuationId(ctx) {
    const lastIdKey = "lastValuationId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    let lastId = 0;
    if (lastIdData && lastIdData.length > 0) {
      lastId = parseInt(lastIdData.toString().substring(3)) || 0;
    }
    const newIdNumber = lastId + 1;
    const newId = `VAL${newIdNumber.toString().padStart(4, "0")}`;
    await ctx.stub.putState(lastIdKey, Buffer.from(newId));
    return newId;
  }

  async createValuation(ctx, prj_id, valuationData) {
    try {
      let valuation = JSON.parse(valuationData);

      // Auto-generate field 1 - generating valuation id
      const newValuationId = await this._generateNextValuationId(ctx);
      valuation.prj_id_val_id = newValuationId;

      const timestamp = ctx.stub.getTxTimestamp();
      const tsDate = new Date(timestamp.seconds.low * 1000);
      valuation.Update_datetime = tsDate.toISOString();

      // Define the required fields
      const requiredFields = [
        "prj_id",
        "val_date",
        "val_company",
        "val_time_period",
        "tot_asset_value",
        "exp_revenue",
        "exp_CC",
        "val_doc_ref",
        "tot_prj_val",
      ];

      // Check for missing fields
      requiredFields.forEach((field) => {
        if (!valuation[field]) {
          throw new Error(`Field ${field} is missing`);
        }
      });

      // Validate the val_time_period
      valuation.val_time_period = valuation.val_time_period || 3; // Default to 3 if not specified
      valuation.val_time_period = Math.min(valuation.val_time_period, 10); // Cap at 10 years

      // Store the data in the ledger using prj_id_val_id as the key
      await ctx.stub.putState(
        newValuationId,
        Buffer.from(JSON.stringify(valuation))
      );

    //changing project status
      await this.invokeChangeProjectStatus(ctx, prj_id, "3");

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

  async updateValuation(ctx, prj_id_val_id, updateValue) {
    try {
      const exists = await this.valuationExists(ctx, prj_id_val_id);
      if (!exists) {
        throw new Error(
          `The valuation with ID ${prj_id_val_id} does not exist`
        );
      }

      // Ensure updateValue does not contain prj_id
      const updateData = JSON.parse(updateValue);
      if (updateData.prj_id) {
        throw new Error("Updating prj_id is not allowed.");
      }

      // Retrieve the current state and prepare for update
      const existingData = await ctx.stub.getState(prj_id_val_id);
      const currentValuation = JSON.parse(existingData.toString());

      // Ensure prj_id remains unchanged by explicitly setting it from currentValuation
      const updatedValuation = {
        ...currentValuation,
        ...updateData,
        prj_id: currentValuation.prj_id,
      };

      // Set update timestamp
      const timestamp = ctx.stub.getTxTimestamp();
      const tsDate = new Date(timestamp.seconds.low * 1000);
      updatedValuation.Update_datetime = tsDate.toISOString();

      // Save the updated state
      await ctx.stub.putState(
        prj_id_val_id,
        Buffer.from(JSON.stringify(updatedValuation))
      );
      return ctx.stub.getTxID();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  async valuationExists(ctx, prj_id_val_id) {
    const valuationJSON = await ctx.stub.getState(prj_id_val_id);
    return valuationJSON && valuationJSON.length > 0;
  }

  async getValuation(ctx, prj_id_val_id) {
    const valuationJSON = await ctx.stub.getState(prj_id_val_id);
    if (!valuationJSON || valuationJSON.length === 0) {
      throw new Error(`The valuation with ID ${prj_id_val_id} does not exist`);
    }
    return valuationJSON.toString();
  }

  async getAllValuationsForProject(ctx, prj_id) {
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
  }

  async getLatestValuationId(ctx) {
    const lastIdKey = "lastValuationId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    if (!lastIdData || lastIdData.length === 0) {
      return "VAL0000";
    }
    return lastIdData.toString();
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
  async getValHistory(ctx, prj_id_val_id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(prj_id_val_id); // corrected parameter name
      let results = await this.getAllResults(resultsIterator, true); // added the second parameter
      console.log("results : ", results);

      return results;
    } catch (err) {
      throw new Error(err.stack); // changed from returning an Error object to throwing an error
    }
  }
}

module.exports = Valuation;
