//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "./Random.sol";
import "../payments/Fees.sol";
abstract contract RandomConsumer {
    Random public random;
    constructor(Random random_) {
        random = random_;
    }
    function rawFulFillRandom(uint requestId, uint result) external {
        require(msg.sender == address(random), "Not allowed.");
        _fulfillRandom(requestId, result);
    }
    function _requestRandom(uint[] memory options) internal returns(uint) {
        return random.requestRandom(options);
    }
    function _fulfillRandom(uint requestId, uint result) internal virtual;
}