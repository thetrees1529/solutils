/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-ethers")

module.exports = {
  networks: {
    devnet: {
      url: "https://api.s0.ps.hmny.io",
      accounts: [require("./privateKey")]
    }
  },

  solidity: "0.8.15"
};
