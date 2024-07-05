const { Sequelize, DataTypes } = require("sequelize");

const sequelize = require("../config/database");

const User = sequelize.define(
  "user",
  {
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    role: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
     }
  },
  {
    timestamps: false,
  }
);

User.sync({ force: false });
module.exports = User;
