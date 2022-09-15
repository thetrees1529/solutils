//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
contract OwnerOf {

    IERC721 private _token;

    constructor(IERC721 token) {
        _token = token;
    }
    
    function _isOwnerOf(address account, uint tokenId) internal view returns(bool) {
        return _token.ownerOf(tokenId) == account;
    }

    modifier onlyOwnerOf(uint tokenId) {
        require(_isOwnerOf(msg.sender, tokenId), "Does not own nft.");
        _;
    }

}