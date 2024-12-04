//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./IPayee.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
abstract contract Payee is ERC165, IPayee {
    mapping(address => bool) private _approvedSenders;
    constructor() {
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
        return interfaceId == type(IPayee).interfaceId || super.supportsInterface(interfaceId);
    }

    function onPaymentReceived(IERC20 token, address from, uint256 value) external override {
        require(_approvedSenders[msg.sender], "Payee: Only approved sender can call this function");
        handlePaymentReceived(token, from, value);
    }

    function handlePaymentReceived(IERC20 token, address from, uint256 value) internal virtual;
}
