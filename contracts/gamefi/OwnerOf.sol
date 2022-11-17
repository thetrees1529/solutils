//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
library OwnerOf {
    
    function isOwnerOf(IERC721 token, address account, uint tokenId) internal view returns(bool) {
        return token.ownerOf(tokenId) == account;
    }

    modifier onlyOwnerOf(IERC721 token, uint tokenId) {
        require(isOwnerOf(token, msg.sender, tokenId), "Does not own nft.");
        _;
    }

}