//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
interface IRandomConsumer {
    function rawFulFillRandom(uint requestId, uint result) external;
}