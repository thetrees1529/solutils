//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./IPayee.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
abstract contract Payee is ERC165, Ownable, IPayee {
    event ApprovedSenderAdded(address sender);
    event ApprovedSenderRemoved(address sender);

    mapping(address => bool) public approvedSenders;
    constructor() {
    }

    function addApprovedSender(address sender) public onlyOwner {
        require(!approvedSenders[sender], "Payee: Sender already approved");
        approvedSenders[sender] = true;
        emit ApprovedSenderAdded(sender);
    }
    function removeApprovedSender(address sender) public onlyOwner {
        require(approvedSenders[sender], "Payee: Sender not approved");
        approvedSenders[sender] = false;
        emit ApprovedSenderRemoved(sender);
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
        return interfaceId == type(IPayee).interfaceId || super.supportsInterface(interfaceId);
    }

    function onPaymentReceived(IERC20 token, address from, uint256 value) external override {
        require(approvedSenders[msg.sender], "Payee: Only approved sender can call this function");
        handlePaymentReceived(token, from, value);
    }

    function handlePaymentReceived(IERC20 token, address from, uint256 value) internal virtual;
}
