"use strict";

const { Contract } = require("fabric-contract-api");

class HealthCheckContract extends Contract {
  async CheckNetworkStatus(ctx) {
    return JSON.stringify({ status: "OK", message: "Network is operational" });
  }
}

module.exports = HealthCheckContract;
