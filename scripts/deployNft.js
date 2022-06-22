const fs = require("fs") 
const path = require("path") 

const testTokens = [0,1,2,3,4,5,6,7,8,9]


async function main() {
    const address = (await hre.ethers.getSigner()).address
    const Nft = await hre.ethers.getContractFactory("Nft")
    const nft = await (await Nft.deploy()).deployed()
    for(let i = 0; i < testTokens.length; i ++) {
        await (await nft.mint(address,testTokens[i])).wait()
    }
    fs.writeFileSync(path.join(__dirname, "deployedNftAddress.json"), JSON.stringify(nft.address))
    console.log(`Nft deployed at ${nft.address}`)
}

main()