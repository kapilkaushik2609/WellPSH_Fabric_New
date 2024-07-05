"use strict";
const log4js = require("log4js");
const logger = log4js.getLogger("BasicNetwork");
const bodyParser = require("body-parser");
const http = require("http");
const util = require("util");
const express = require("express");
const app = express();
const expressJWT = require("express-jwt");
const jwt = require("jsonwebtoken");
const bearerToken = require("express-bearer-token");
const cors = require("cors");
require("dotenv").config();
const constants = require("./config/constants.json");
const User = require("./models/user.model");

const host = process.env.HOST || constants.host;
const port = process.env.PORT || constants.port;

const helper = require("./app/helper");
const invoke = require("./app/invoke");
const query = require("./app/query");
require("./config/database");

app.use(express.json());
app.use(bodyParser.json());
app.options("*", cors());
app.use(cors());
app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);
app.use(express.urlencoded({ extended: true }));
// set secret variable
app.set("secret", "thisismysecret");
app.use(
  expressJWT({
    secret: "thisismysecret",
  }).unless({
    path: ["/users", "/users/login", "/register"],
  })
);
app.use(bearerToken());

logger.level = "debug";

app.use((req, res, next) => {
  logger.debug("New req for %s", req.originalUrl);
  if (
    req.originalUrl.indexOf("/users") >= 0 ||
    req.originalUrl.indexOf("/users/login") >= 0 ||
    req.originalUrl.indexOf("/register") >= 0
  ) {
    return next();
  }
  var token = req.token;
  jwt.verify(token, app.get("secret"), (err, decoded) => {
    if (err) {
      console.log(`Error ================:${err}`);
      res.send({
        success: false,
        message:
          "Failed to authenticate token. Make sure to include the " +
          "token returned from /users call in the authorization header " +
          " as a Bearer token",
      });
      return;
    } else {
      req.username = decoded.username;
      req.orgname = decoded.orgName;
      logger.debug(
        util.format(
          "Decoded from JWT token: username - %s, orgname - %s",
          decoded.username,
          decoded.orgName
        )
      );
      return next();
    }
  });
});

// var server = http.createServer(app).listen(port, function () {
//   console.log(`Server started on ${port}`);
var server = http.createServer(app).listen(port, '0.0.0.0', function () {
  console.log(`Server started on ${host}:${port}`);
});
logger.info("****************** SERVER STARTED ************************");
logger.info("***************  http://%s:%s  ******************", host, port);
server.timeout = 240000;

function getErrorMessage(field) {
  var response = {
    success: false,
    message: field + " field is missing or Invalid in the request",
  };
  return response;
}

// Register and enroll user
app.post("/users", async function (req, res) {
  console.log(req.body);
  var username = req.body.username;
  var orgName = req.body.orgName;
  logger.debug("End point : /users");
  logger.debug("User name : " + username);
  logger.debug("Org name  : " + orgName);
  if (!username) {
    res.json(getErrorMessage("'username'"));
    return;
  }
  if (!orgName) {
    res.json(getErrorMessage("'orgName'"));
    return;
  }

  var token = jwt.sign(
    {
      exp: Math.floor(Date.now() / 1000) + parseInt(constants.jwt_expiretime),
      username: username,
      orgName: orgName,
    },
    app.get("secret")
  );

  let response = await helper.getRegisteredUser(username, orgName, true);

  logger.debug(
    "-- returned from registering the username %s for organization %s",
    username,
    orgName
  );
  if (response && typeof response !== "string") {
    logger.debug(
      "Successfully registered the username %s for organization %s",
      username,
      orgName
    );
    response.token = token;
    res.json(response);
  } else {
    logger.debug(
      "Failed to register the username %s for organization %s with::%s",
      username,
      orgName,
      response
    );
    res.json({ success: false, message: response });
  }
});

// Register and enroll user
app.post("/register", async function (req, res) {
  var username = req.body.username;
  var orgName = req.body.orgName;
  logger.debug("End point : /users");
  logger.debug("User name : " + username);
  logger.debug("Org name  : " + orgName);
  if (!username) {
    res.json(getErrorMessage("'username'"));
    return;
  }
  if (!orgName) {
    res.json(getErrorMessage("'orgName'"));
    return;
  }

  var token = jwt.sign(
    {
      exp: Math.floor(Date.now() / 1000) + parseInt(constants.jwt_expiretime),
      username: username,
      orgName: orgName,
    },
    app.get("secret")
  );

  console.log(token);

  let response = await helper.registerAndGerSecret(username, orgName);

  logger.debug(
    "-- returned from registering the username %s for organization %s",
    username,
    orgName
  );
  if (response && typeof response !== "string") {
    logger.debug(
      "Successfully registered the username %s for organization %s",
      username,
      orgName
    );
    response.token = token;
    res.json(response);
  } else {
    logger.debug(
      "Failed to register the username %s for organization %s with::%s",
      username,
      orgName,
      response
    );
    res.json({ success: false, message: response });
  }
});

// Login and get jwt
app.post("/users/login", async function (req, res) {
  const { username: nodeUsername, password } = req.body;
  logger.debug("End point : /users");
  logger.debug("User name : " + nodeUsername);
  logger.debug("Password  : " + password);
  if (!nodeUsername) {
    res.json(getErrorMessage("'username'"));
    return;
  }
  if (!password) {
    res.json(getErrorMessage("'password'"));
    return;
  }

  // const userExists = await User.findOne({ username: nodeUsername });
  const userExists = await User.findOne({ where: { username: nodeUsername } });

  if (!userExists) {
    return res.json({
      success: false,
      message: "User not exists. Please sign in",
    });
  }

  if (password !== userExists.password) {
    return res.json({
      success: false,
      message: "Password not matched. Try again!",
    });
  }

  const username = "hiam";
  const orgName = "Org1";

  var token = jwt.sign(
    {
      exp: Math.floor(Date.now() / 1000) + parseInt(constants.jwt_expiretime),
      username: username,
      orgName: orgName,
    },
    app.get("secret")
  );

  let isUserRegistered = await helper.isUserRegistered(username, orgName);

  if (isUserRegistered) {
    res.json({
      success: true,
      message: { token: token, role: userExists.role },
    });
  } else {
    res.json({
      success: false,
      message: `User with username ${username} is not registered with ${orgName}, Please register first.`,
    });
  }
});

// Invoke transaction on chaincode on target peers
app.post(
  "/channels/:channelName/chaincodes/:chaincodeName",
  async function (req, res) {
    try {
      logger.debug(
        "==================== INVOKE ON CHAINCODE =================="
      );
      var peers = req.body.peers;
      var chaincodeName = req.params.chaincodeName;
      var channelName = req.params.channelName;
      var fcn = req.body.fcn;
      var args = req.body.args;

      console.log("res", args, fcn);
      // var transient = req.body.transient;
      // console.log(`Transient data is ;${transient}`)
      logger.debug("channelName  : " + channelName);
      logger.debug("chaincodeName : " + chaincodeName);
      logger.debug("fcn  : " + fcn);
      logger.debug("args  : " + args);
      if (!chaincodeName) {
        res.json(getErrorMessage("'chaincodeName'"));
        return;
      }
      if (!channelName) {
        res.json(getErrorMessage("'channelName'"));
        return;
      }
      if (!fcn) {
        res.json(getErrorMessage("'fcn'"));
        return;
      }
      if (!args) {
        res.json(getErrorMessage("'args'"));
        return;
      }
      let message = await invoke.invokeTransaction(
        channelName,
        chaincodeName,
        fcn,
        args,
        req.username,
        req.orgname
      );
      console.log(`message result is : ${message}`);

      const response_payload = {
        result: message,
        error: null,
        errorData: null,
      };
      res.send(response_payload);
    } catch (error) {
      const response_payload = {
        result: null,
        error: error.name,
        errorData: error.message,
      };
      res.send(response_payload);
    }
  }
);

app.get(
  "/channels/:channelName/chaincodes/:chaincodeName",
  async function (req, res) {
    try {
      logger.debug(
        "==================== QUERY BY CHAINCODE =================="
      );

      console.log("here");

      var channelName = req.params.channelName;
      var chaincodeName = req.params.chaincodeName;
      console.log(`chaincode name is :${chaincodeName}`);
      let args = req.query.args;
      let fcn = req.query.fcn;

      console.log("req query", req.query);
      // var fcn = req.body.fcn;
      // var args = req.body.args;
      let peer = req.query.peer;

      console.log("are we here1");
      logger.debug("channelName : " + channelName);
      logger.debug("chaincodeName : " + chaincodeName);
      logger.debug("fcn : " + fcn);
      logger.debug("args : " + args);
      console.log("why not here");

      if (!chaincodeName) {
        res.json(getErrorMessage("'chaincodeName'"));
        return;
      }
      if (!channelName) {
        res.json(getErrorMessage("'channelName'"));
        return;
      }
      if (!fcn) {
        res.json(getErrorMessage("'fcn'"));
        return;
      }
      if (!args) {
        res.json(getErrorMessage("'args'"));
        return;
      }

      console.log("args==========", args);
      args = args.replace(/'/g, '"');
      args = JSON.parse(args);
      logger.debug(args);

      let message = await query.query(
        channelName,
        chaincodeName,
        args,
        fcn,
        req.username,
        req.orgname
      );

      const response_payload = {
        result: message,
        error: null,
        errorData: null,
      };

      res.send(response_payload);
    } catch (error) {
      const response_payload = {
        result: null,
        error: error.name,
        errorData: error.message,
      };
      res.send(response_payload);
    }
  }
);

app.get("/api/health", async (req, res) => {
  try {
    const channelName = "channel1";
    const chaincodeName = "HealthCheckContract";
    const fcn = req.query.fcn || "CheckNetworkStatus"; // defaulting to "CheckNetworkStatus" if not specified
    const args = req.query.args || []; // defaulting to empty if not specified

    console.log(`Function: ${fcn}, Args: ${args}`); // Debug: Log function and arguments

    const message = await query.query(
      channelName,
      chaincodeName,
      args,
      fcn,
      "admin",
      "Org1"
    );
    console.log("Chaincode response:", message); // Log raw response

    // const result = JSON.parse(message); // Attempt to parse the chaincode response

    if (message.status === "OK") {
      res.json({
        status: "OK",
        message: "Hyperledger Network is operational.",
        details: message.message,
      });
    } else {
      throw new Error(
        "Asset Monetization channel not ready! Please check with Admin..."
      );
    }
  } catch (error) {
    console.error("Failed to parse JSON:", error); // More detailed error logging
    res.status(500).json({
      status: "ERROR",
      message: "Hyperledger Network is not operational.",
      error: error.toString(),
    });
  }
});
