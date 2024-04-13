// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Nft is AccessControl, ERC721Enumerable {

    string private baseUri;
    uint private _nextTokenId;

    constructor(string memory uri, string memory name, string memory symbol) ERC721(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setBaseURI(uri);
    }

    function supportsInterface(bytes4 interfaceId) public virtual override(AccessControl, ERC721Enumerable) view returns(bool) {
        return super.supportsInterface(interfaceId);
    }

    function ownersOf(uint[] calldata tokenIds) external view returns(address[] memory owners) {
        owners = new address[](tokenIds.length);
        for(uint i; i < tokenIds.length; i ++) {
            owners[i] = ownerOf(tokenIds[i]);
        }
    }

    function tokensOf(address owner) external view returns(uint[] memory tokenIds) {
        uint balance = balanceOf(owner);
        tokenIds = new uint[](balance);
        for(uint i; i < balance; i ++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }
    }

    function mint(address to, uint numberOf) external onlyRole(DEFAULT_ADMIN_ROLE) returns(uint[] memory tokenIds){
        tokenIds = new uint[](numberOf);
        uint tokenId = _nextTokenId;
        _nextTokenId += numberOf;
        for(uint i; i < numberOf; i ++){
            _mint(to, tokenId);
            tokenIds[i] = tokenId;
            tokenId ++;
        }
    }

    function burn(uint[] calldata tokenIds) external onlyRole(DEFAULT_ADMIN_ROLE) {
        for(uint i; i < tokenIds.length; i ++) {
            _burn(tokenIds[i]);
        }
    }

    function burn(uint tokenId) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _burn(tokenId);
    }

    function setBaseURI(string memory _newUri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setBaseURI(_newUri);
    }

    function _setBaseURI(string memory _newUri) private {
        baseUri = _newUri;
    }

    // hooks / overrides

    function _baseURI() internal virtual override view returns(string memory) {
        return baseUri;
    }

}