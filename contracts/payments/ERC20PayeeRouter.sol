//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./ERC20Payments.sol";
import "./Payee.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20PayeeRouter is Payee, Ownable {

    ERC20Payments.Payee[] private _payees;

    function getPayees() public view returns (ERC20Payments.Payee[] memory) {
        return _payees;
    }

    function setPayees(ERC20Payments.Payee[] memory payees) public onlyOwner {
        _payees = payees;
    }

    function onPaymentReceived(IERC20 token, address from, uint value) override external returns (bool) {
        ERC20Payments.split(token, value, _payees);
        return true;
    }

}
