//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "./Random.sol";
import "../payments/Fees.sol";
abstract contract RandomConsumer {
    Random public random;
    constructor(Random random_) {
        random = random_;
    }
    function _requestRandom(Fees.Fee[] calldata chances) internal returns(uint) {
        return random.requestRandom(chances);
    }
    function rawFulFillRandom(uint requestId, bool[] calldata results) external {
        require(msg.sender == address(random), "Not allowed.");
        _fulfillRandom(requestId, results);
    }
    function _fulfillRandom(uint requestId, bool[] calldata results) internal virtual;
}