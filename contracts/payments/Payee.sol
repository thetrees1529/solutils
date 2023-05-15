//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./IPayee.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
abstract contract Payee is ERC165, IPayee {
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
        return interfaceId == type(IPayee).interfaceId || super.supportsInterface(interfaceId);
    }
}
