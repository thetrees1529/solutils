//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
contract Payments {
    struct Payee {
        address addr;
        uint weighting;
    }
    event PayeesSet(Payee[] payees);
    event PayeesDeleted();
    Payee[] private _payees;
    uint private _totalWeighting;
    constructor() {
        Payee[] memory payees = new Payee[](1);
        payees[0] = Payee(msg.sender,1);
        _setPayees(payees);
    }
    function getPayees() external virtual view returns(Payee[] memory) {
        return _payees;
    }
    function _setPayees(Payee[] memory payees) internal virtual {
        if(_payees.length > 0) _deletePayees();
        for(uint i; i < payees.length; i++) {
            Payee memory payee = payees[i];
            require(payee.weighting > 0, "All payees must have a weighting.");
            require(payee.addr != address(0), "Payee cannot be the zero address.");
            _totalWeighting += payee.weighting;
            _payees.push(payee);
        }
        emit PayeesSet(payees);
    }
    function _tryMakePayment(uint value) internal virtual {
        for(uint i; i < _payees.length; i ++) {
            Payee storage payee = _payees[i];
            uint payment = (payee.weighting * value) / _totalWeighting;
            (bool succ,) = payee.addr.call{value: payment}("");
            require(succ, "Issue with one of the payees.");
        }
    }
    function _makePayment(uint value) internal virtual {
        require(_payees.length > 0, "No payees set up.");
        _tryMakePayment(value);
    }
    function _deletePayees() internal virtual {
        delete _totalWeighting;
        delete _payees;
        emit PayeesDeleted();
    }
}