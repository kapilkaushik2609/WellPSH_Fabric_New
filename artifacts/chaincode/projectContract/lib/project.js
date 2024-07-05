"use strict";

const { Contract } = require("fabric-contract-api");

class Project extends Contract {
  //PRJ0000 (default project ID stored in blockchain ledger if no data)
  async initLedger(ctx) {
    console.info("Initializing ledger with default lastProjectId 'PRJ0000'");
    await ctx.stub.putState("lastProjectId", Buffer.from("PRJ0000"));
    console.info("Ledger initialization complete");
  }

  //helper function to auto-generate prj_id
  async _generateNextProjectId(ctx) {
    const lastIdKey = "lastProjectId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    let lastId = 0;
    if (lastIdData && lastIdData.length > 0) {
      lastId = parseInt(lastIdData.toString().substring(3)) || 0; // Extract the numeric part
    }
    const newIdNumber = lastId + 1;
    const newId = `PRJ${newIdNumber.toString().padStart(4, "0")}`;
    await ctx.stub.putState(lastIdKey, Buffer.from(newId)); // Store the new lastPrjectId
    return newId;
  }

  //save button in project page
  async createProject(ctx, projectData) {
    const project = JSON.parse(projectData);

    //auto generate field 1 -generating project id
    const newProjectId = await this._generateNextProjectId(ctx);
    project.prj_id = newProjectId;
    project.prj_status = "1"; // Set the project status to "1" after generating the new project ID

    const timestamp = ctx.stub.getTxTimestamp();
    const tsDate = new Date(timestamp.seconds.low * 1000);
    project.prj_lastupdate_user = tsDate.toISOString();

    //checking for mandatory fields [Provided by UI]
    const requiredFields = [
      "prj_name",
      "prj_company",
      "prj_company_details",
      "prj_description",
      "prj_sba_id",
      "prj_sba_address",
      "prj_sba_landmark",
      "prj_sba_lat",
      "prj_sba_long",
      "prj_sba_details",
      "prj_sba_media_list",
      "prj_status",
      "asset_services_list",
      "prj_nft_id",
      "prj_valuation",
      "prj_start_date",
      "prj_end_date",
      "prj_lastupdate_user",
    ];

    //Throws error if there is missing field
    requiredFields.forEach((field) => {
      if (!project[field]) {
        throw new Error(`Field ${field} is missing`);
      }
    });

    //Date validation
    if (new Date(project.prj_start_date) > new Date(project.prj_end_date)) {
      throw new Error("The start date must be earlier than the end date.");
    }

    // Store the project in blockchain ledger
    await ctx.stub.putState(newProjectId, Buffer.from(JSON.stringify(project)));
    return ctx.stub.getTxID();
  }

  //uodateValue only replaces fields that are being changed from UI, unchanged data will remain same/ validation for prj_id is included
  async updateProject(ctx, prj_id, updateValuesJson) {
    // Check if the project exists
    const exists = await this.projectExists(ctx, prj_id);
    if (!exists) {
      throw new Error(`The project with ID ${prj_id} does not exist`);
    }

    // Parse the update values
    const updateValues = JSON.parse(updateValuesJson);

    // Fetch the existing project data
    const projectData = await ctx.stub.getState(prj_id);
    const project = JSON.parse(projectData.toString());

    // Update fields provided in the update payload
    Object.keys(updateValues).forEach((key) => {
      project[key] = updateValues[key];
    });

    const timestamp = ctx.stub.getTxTimestamp();
    const tsDate = new Date(timestamp.seconds.low * 1000);
    project.prj_lastupdate_user = tsDate.toISOString();

    // Validate date fields if they are updated
    if (project.prj_start_date && project.prj_end_date) {
      if (new Date(project.prj_start_date) > new Date(project.prj_end_date)) {
        throw new Error("The start date must be earlier than the end date.");
      }
    }

    // Store the updated project back into the ledger
    await ctx.stub.putState(prj_id, Buffer.from(JSON.stringify(project)));
    return ctx.stub.getTxID();
  }

  // gets all Keys stored in the ledger
  async getAllProjects(ctx) {
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

        allResults.push({ Key: result.value.key, Record: record });
        result = await iterator.next();
      }

      return JSON.stringify(allResults);
    } catch (err) {
      throw new Error(err.message);
    }
  }

  //gets all data including timestamp for particular key
  async getProject(ctx, prj_id) {
    try {
      const assetJSON = await ctx.stub.getState(prj_id);

      if (!assetJSON || assetJSON.length === 0) {
        throw new Error(`The project with ID ${prj_id} does not exist`);
      }

      return assetJSON.toString();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  //helper function for validation for project ID
  async projectExists(ctx, prj_id) {
    const assetJSON = await ctx.stub.getState(prj_id);
    return assetJSON && assetJSON.length > 0;
  }

  //helper function for blockchain history
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

  //fetches complete blokchain history for particular key
  async getProjectHistory(ctx, prj_id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(prj_id);
      let results = await this.getAllResults(resultsIterator, true);
      console.log("results : ", results);

      return results;
    } catch (err) {
      return new Error(err.stack);
    }
  }

  async getLatestProjectId(ctx) {
    const lastIdKey = "lastProjectId";
    const lastIdData = await ctx.stub.getState(lastIdKey);
    if (!lastIdData || lastIdData.length === 0) {
      return "PRJ0000";
    }
    return lastIdData.toString();
  }

  async getProjectStatus(ctx, prj_id) {
    const projectData = await ctx.stub.getState(prj_id);
    if (!projectData || projectData.length === 0) {
      throw new Error(`The project with ID ${prj_id} does not exist`);
    }
    const project = JSON.parse(projectData.toString());
    return project.prj_status;
  }

  // Function to get the project valuation for a specific project ID
  async getProjectValuation(ctx, prj_id) {
    const projectDataBytes = await ctx.stub.getState(prj_id); // Retrieve the project data from ledger

    if (!projectDataBytes || projectDataBytes.length === 0) {
      throw new Error(`Project with ID ${prj_id} does not exist`);
    }

    const projectData = JSON.parse(projectDataBytes.toString());
    if (!projectData.prj_valuation) {
      throw new Error(`Project valuation for ID ${prj_id} is not set`);
    }

    // Return only the project valuation
    return projectData.prj_valuation.toString();
  }

  /**
   * Changes the status of an existing project.
   * @param {Context} ctx - The transaction context.
   * @param {String} prj_id - The ID of the project whose status is to be updated.
   * @param {String} status - The new status to set.
   * @returns {String} Transaction ID of the status update transaction.
   */
  async changeProjectStatus(ctx, prj_id, status) {
    // First, check if the project exists in the ledger
    const projectData = await ctx.stub.getState(prj_id);
    if (!projectData || projectData.length === 0) {
      throw new Error(`The project with ID ${prj_id} does not exist`);
    }

    // Parse the existing project data from the ledger
    const project = JSON.parse(projectData.toString());

    // Update the project status
    project.prj_status = status;

    // Record this update as a transaction, setting the updated project back into the ledger
    await ctx.stub.putState(prj_id, Buffer.from(JSON.stringify(project)));

    // Return the transaction ID to confirm the transaction was processed
    return ctx.stub.getTxID();
  }
}

module.exports = Project;
