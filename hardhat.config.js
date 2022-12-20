/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-ethers")
const fs = require("fs")
const path = `${__dirname}/privateKey.json`
const privKey = fs.existsSync(path) ? require(path) : undefined

module.exports = {
  networks: privKey ? {
    devnet: {
      url: "https://api.s0.ps.hmny.io",
      accounts: [privKey]
    } 
  } : undefined,

  solidity: "0.8.15"
};
