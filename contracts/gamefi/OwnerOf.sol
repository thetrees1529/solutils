//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
library OwnerOf {
    function _isOwnerOf(IERC721 token, uint tokenId,address account) internal view returns(bool) {
        return token.ownerOf(tokenId) == account;
    }
    modifier onlyOwnerOf(IERC721 token, uint tokenId, address account) {
        require(_isOwnerOf(token, tokenId,account), "Does not own nft.");
        _;
    }
}