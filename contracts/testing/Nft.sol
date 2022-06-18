//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Nft is ERC721("Nft","NFT"), Ownable {
    function mint(address account, uint tokenId) external onlyOwner {
        _mint(account, tokenId);
    }
}