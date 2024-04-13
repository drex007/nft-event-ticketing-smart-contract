require("@nomicfoundation/hardhat-toolbox");
const dotenv = require('dotenv')
dotenv.config()

const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || ""
const ALCHEMY_KEY = process.env.ALCHEMY_KEY || ""


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: 'localhost',
  networks: {
    hardhat: {},
    localhost: {
      url: 'http://127.0.0.1:8545',
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_KEY}`,
      accounts: [PRIVATE_KEY],
      chainId: 11155111,
      timeout: 120000,
    },
  },
  solidity: {
    compilers: [
      { version: "0.7.3" },
      { version: "0.8.0" },
      { version: "0.8.24" }
    ]
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
};
