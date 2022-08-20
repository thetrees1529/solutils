//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
contract Shared {
    struct Payee {
        address addr;
        uint weighting;
    }
    event PayeesSet(Payee[] payees);
    event PayeesDeleted();
}
