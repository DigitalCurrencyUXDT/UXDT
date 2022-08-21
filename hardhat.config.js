require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: "",
  networks: {
    bsc: {
      url: 'https://bsc-dataseed1.defibit.io/',
      accounts: ['']
    },
    eth: {
      url: 'https://mainnet.infura.io/v3/...',
      accounts: ['']
    }
  },
  etherscan: {
    apiKey: ''
  },
  solidity: {
    compilers: [
      {
        version: "0.8.0"
      }
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 60000
  }
}
