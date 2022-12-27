//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "./IRandom.sol";
import "../payments/Fees.sol";
import "./IRandomConsumer.sol";
abstract contract RandomConsumer is IRandomConsumer {
    IRandom public random;
    constructor(IRandom random_) {
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