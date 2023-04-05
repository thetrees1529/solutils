//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

interface IPayee is IERC165 {
    function onPaymentReceived(IERC20 token, address from, uint value) external returns (bool);
}

library ERC20Payments {

    using SafeERC20 for IERC20;

    struct Payee {
        address addr;
        uint weighting;
    }

    function split(IERC20 token, uint value, Payee[] memory payees) internal {
        splitFrom(token, address(this), value, payees);
    }

    function splitFrom(IERC20 token, address from, uint value, Payee[] memory payees) internal {
        uint totalWeighting;
        for(uint i; i < payees.length; i ++) {
            totalWeighting += payees[i].weighting;
        }
        require(totalWeighting > 0, "ERC20Payments: must have at least 1 weighting.");
        for(uint i; i < payees.length; i ++) {
            Payee memory payee = payees[i];
            uint payment = (payee.weighting * value) / totalWeighting;
            _send(token,from, payee.addr, payment);
        }
    }

    function _send(IERC20 token, address from, address to, uint value) private {
        if(from == address(this)) token.safeTransfer(to,value);
        else token.safeTransferFrom(from, to, value);
        if(ERC165Checker.supportsInterface(to, type(IPayee).interfaceId)) {
            require(IPayee(to).onPaymentReceived(token, from, value), "ERC20Payments: payee rejected payment.");
        }
    }

}