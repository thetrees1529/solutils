// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

abstract contract Nft is AccessControl, ERC721Enumerable {

    string private baseUri;

    constructor(string memory uri) {
        _setBaseURI(uri);
    }

    function supportsInterface(bytes4 interfaceId) public virtual override(AccessControl, ERC721Enumerable) view returns(bool) {
        return super.supportsInterface(interfaceId);
    }

    function setBaseURI(string memory _newUri) public onlyRole(DEFAULT_ADMIN_ROLE) {
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