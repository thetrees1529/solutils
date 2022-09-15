//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
library OwnerOf {
    function _isOwnerOf(address account, IERC721 token, uint tokenId) internal view returns(bool) {
        return token.ownerOf(tokenId) == account;
    }
    modifier onlyOwnerOf(address account, IERC721 token, uint tokenId) {
        require(_isOwnerOf(account, token, tokenId), "Does not own nft.");
        _;
    }
}