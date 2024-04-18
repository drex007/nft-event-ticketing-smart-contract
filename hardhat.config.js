require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
const dotenv = require('dotenv')
dotenv.config()

const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || ""
const ALCHEMY_KEY = process.env.ALCHEMY_KEY || ""
const ETHERSCAN_APIKEY = process.env.ETHERSCAN_APIKEY || ""


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: 'localhost',
  networks: {
    // hardhat: {},
    // localhost: {
    //   url: 'http://127.0.0.1:8545',
    // },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_KEY}`,
      accounts: [PRIVATE_KEY],
      chainId: 11155111,
      timeout: 120000,
    },
    tMorph: {
      url: 'https://rpc-testnet.morphl2.io',
      accounts: [PRIVATE_KEY],
      chainId: 2710,
      timeout: 120000,
      gas: 30000,
    },
  },
  solidity: {
    compilers: [
      { version: "0.7.3" },
      { version: "0.8.0" },
      { version: "0.8.24" },
      { version: "0.8.25" }
    ]
  },
  etherscan: {
    apiKey: ETHERSCAN_APIKEY,
    customChains: [
      {
        network: "tMorph",
        chainId: 2710,
        urls: {
          apiURL: "https://explorer-api-testnet.morphl2.io/api",
          browserURL: "https://explorer-testnet.morphl2.io",
        },
      },
    ],
  },
  sourcify: {
    // Disabled by default
    // Doesn't need an API key
    enabled: true
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },

};