const fs = require("fs") 
const path = require("path") 

const initialMint = hre.ethers.utils.parseEther("1000000")

async function main() {
    const address = (await hre.ethers.getSigner()).address
    const Token = await hre.ethers.getContractFactory("Token")
    const token = await (await Token.deploy()).deployed()
    await (await token.mint(address, initialMint)).wait()
    fs.writeFileSync(path.join(__dirname, "deployedTokenAddress.json"), JSON.stringify(token.address))
    console.log(`Token deployed at ${token.address}`)
}

main()