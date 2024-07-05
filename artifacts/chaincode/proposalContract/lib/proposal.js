"use strict";

const { Contract } = require("fabric-contract-api");

class Proposal extends Contract {
  async initLedgerProposal(ctx) {
    console.info("Initializing ledger with default lastProposalId 'PROP0000'");
    await ctx.stub.putState("lastProposalId", Buffer.from("PROP0000"));
    console.info("Ledger initialization complete");
  }

  async _generateNextProposalId(ctx) {
    const lastIdKey = "lastProposalId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    let lastId = 0;
    if (lastIdData && lastIdData.length > 0) {
      lastId = parseInt(lastIdData.toString().substring(4)) || 0;
    }
    const newIdNumber = lastId + 1;
    const newId = `PROP${newIdNumber.toString().padStart(4, "0")}`;
    await ctx.stub.putState(lastIdKey, Buffer.from(newId));
    return newId;
  }

  async createProposal(ctx, prj_id, proposalData) {
    try {
      let proposal = JSON.parse(proposalData);

      // Auto-generate field 1 - generating proposal id
      const newProposalId = await this._generateNextProposalId(ctx);
      proposal.proposal_id = newProposalId;

      const timestamp = ctx.stub.getTxTimestamp();
      const tsDate = new Date(timestamp.seconds.low * 1000);
      proposal.Update_datetime = tsDate.toISOString();

      // Define the required fields
      const requiredFields = [
        "prj_id",
        "proposal_date",
        "proposal_doc_ref",
        "tot_prj_val",
        "Proposal_summary",
      ];

      // Check for missing fields
      requiredFields.forEach((field) => {
        if (!proposal[field]) {
          throw new Error(`Field ${field} is missing`);
        }
      });

      // Store the data in the ledger using proposal_id as the key
      await ctx.stub.putState(
        newProposalId,
        Buffer.from(JSON.stringify(proposal))
      );

      //changing project status
       await this.invokeChangeProjectStatus(ctx, prj_id, "4");
      
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

  async updateProposal(ctx, proposal_id, updateValue) {
    try {
      const exists = await this.proposalExists(ctx, proposal_id);
      if (!exists) {
        throw new Error(`The proposal with ID ${proposal_id} does not exist`);
      }

      // Ensure updateValue does not contain prj_id
      const updateData = JSON.parse(updateValue);
      if (updateData.prj_id) {
        throw new Error("Updating prj_id is not allowed.");
      }

      // Retrieve the current state and prepare for update
      const existingData = await ctx.stub.getState(proposal_id);
      const currentProposal = JSON.parse(existingData.toString());

      // Ensure prj_id remains unchanged by explicitly setting it from currentProposal
      const updatedProposal = {
        ...currentProposal,
        ...updateData,
        prj_id: currentProposal.prj_id,
      };

      // Set update timestamp
      const timestamp = ctx.stub.getTxTimestamp();
      const tsDate = new Date(timestamp.seconds.low * 1000);
      updatedProposal.Update_datetime = tsDate.toISOString();

      // Save the updated state
      await ctx.stub.putState(
        proposal_id,
        Buffer.from(JSON.stringify(updatedProposal))
      );
      return ctx.stub.getTxID();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  async proposalExists(ctx, proposal_id) {
    const proposalJSON = await ctx.stub.getState(proposal_id);
    return proposalJSON && proposalJSON.length > 0;
  }

  async getProposal(ctx, proposal_id) {
    const proposalJSON = await ctx.stub.getState(proposal_id);
    if (!proposalJSON || proposalJSON.length === 0) {
      throw new Error(`The proposal with ID ${proposal_id} does not exist`);
    }
    return proposalJSON.toString();
  }

  async getAllProposalsForProject(ctx, prj_id) {
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

  async getLatestProposalId(ctx) {
    const lastIdKey = "lastProposalId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    if (!lastIdData || lastIdData.length === 0) {
      return "PROP0000";
    }
    return lastIdData.toString();
  }

  // helper function for blockchain history
  async getAllResults(iterator, isHistory) {
    try {
      let allResults = [];
      while (true) {
        let res = await iterator.next();

        if (res.value && res.value.value.toString()) {
          let jsonRes = {};
          if (isHistory && isHistory === true) {
            jsonRes.txId = res.value.txId;
            jsonRes.Timestamp = res.value.timestamp;
            jsonRes.IsDelete = res.value.is_delete
              ? res.value.is_delete.toString()
              : "false";
            try {
              jsonRes.Value = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              jsonRes.Value = res.value.value.toString("utf8");
            }
          } else {
            jsonRes.Key = res.value.key;
            try {
              jsonRes.Record = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              jsonRes.Record = res.value.value.toString("utf8");
            }
          }
          allResults.push(jsonRes);
        }
        if (res.done) {
          await iterator.close();
          return allResults;
        }
      }
    } catch (err) {
      return new Error(err.message);
    }
  }

  // gets blockchain history for proposal id
  async getProposalHistory(ctx, proposal_id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(proposal_id);
      let results = await this.getAllResults(resultsIterator, true);

      return results;
    } catch (err) {
      throw new Error(err.stack);
    }
  }
}

module.exports = Proposal;
