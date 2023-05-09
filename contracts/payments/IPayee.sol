//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
interface IPayee is IERC165 {
    function onPaymentReceived(IERC20 token, address from, uint value) external returns (bool);
}
