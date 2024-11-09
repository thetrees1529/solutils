//SPDX-License-Identifier: Unlicenced
pragma solidity ^0.8.0;
import "./ERC20Payments.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20PayeeStore is Ownable {
    ERC20Payments.Payee[] private _payees;

    function getPayees() public view returns (ERC20Payments.Payee[] memory) {
        return _payees;
    }

    function setPayees(ERC20Payments.Payee[] calldata payees) public onlyOwner {
        _setPayees(payees);
    }

    function _setPayees(ERC20Payments.Payee[] memory payees) internal {
        delete _payees;
        for(uint i; i < payees.length; i ++) {
            _payees.push(payees[i]);
        }
    }
}