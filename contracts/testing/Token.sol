//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20("Token","TKN"), Ownable {
    function mint(address account, uint amount) external onlyOwner {
        _mint(account, amount);
    }
}