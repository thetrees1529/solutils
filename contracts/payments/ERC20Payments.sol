//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC20Payments {
    using SafeERC20 for IERC20;
    struct Payee {
        address addr;
        uint weighting;
    }
    event PayeesSet(Payee[] payees);
    event PayeesDeleted();

    Payee[] private _payees;
    uint private _totalWeighting;
    IERC20 private _token;
    constructor(IERC20 token) {
        _token = token;
        Payee[] memory payees = new Payee[](1);
        payees[0] = Payee(msg.sender,1);
        _setPayees(payees);
    }
    function getPayees() external view returns(Payee[] memory) {
        return _payees;
    }
    function _setPayees(Payee[] memory payees) internal {
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
    function _tryMakePayment(uint value) internal {
        for(uint i; i < _payees.length; i ++) {
            Payee storage payee = _payees[i];
            uint payment = (payee.weighting * value) / _totalWeighting;
            _token.safeTransfer(payee.addr, payment);
        }
    }
    function _makePayment(uint value) internal {
        require(_payees.length > 0, "No payees set up.");
        _tryMakePayment(value);
    }
    function _deletePayees() internal {
        delete _totalWeighting;
        delete _payees;
        emit PayeesDeleted();
    }
}