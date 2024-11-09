//SPDX-License-Identifier: Unlicenced
pragma solidity ^0.8.0;
import "./ERC20Payments.sol";

contract ERC20PayeeStore {
    ERC20Payments.Payee[] internal _payees;

    constructor(ERC20Payments.Payee[] memory payees) {
        _setPayees(payees);
    }

    function getPayees() public view returns (ERC20Payments.Payee[] memory) {
        return _payees;
    }

    function _setPayees(ERC20Payments.Payee[] memory payees) internal {
        delete _payees;
        for(uint i; i < payees.length; i ++) {
            _payees.push(payees[i]);
        }
    }
}