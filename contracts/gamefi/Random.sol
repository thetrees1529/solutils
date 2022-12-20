//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "../payments/Fees.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./RandomConsumer.sol";
contract Random is VRFConsumerBaseV2, AccessControl {
    using Counters for Counters.Counter;
    using Fees for uint;
    Counters.Counter private _nextRequestId;
    uint32 public constant numWords = 1;
    bytes32 public constant CONSUMER_ROLE = keccak256("CONSUMER_ROLE");
    bytes32 public keyHash;uint64 public subId;uint16 public minimumRequestConfirmations;uint32 public callbackGasLimit;
    constructor(VRFCoordinatorV2Interface vrfCoordinator_, bytes32 keyHash_,uint64 subId_,uint16 minimumRequestConfirmations_,uint32 callbackGasLimit_) VRFConsumerBaseV2(address(vrfCoordinator)) {
        vrfCoordinator = vrfCoordinator_;
        (keyHash, subId, minimumRequestConfirmations, callbackGasLimit) = (keyHash_, subId_, minimumRequestConfirmations_, callbackGasLimit_);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    VRFCoordinatorV2Interface public vrfCoordinator;
    struct Request {
        uint requestId;
        RandomConsumer from;
        Fees.Fee[] chances;
    }

    mapping(uint => Request) private _requests;
    function requestRandom(Fees.Fee[] calldata chances) external onlyRole(CONSUMER_ROLE) returns(uint requestId) {
        requestId = _nextRequestId.current();
        _requests[vrfCoordinator.requestRandomWords(keyHash, subId, minimumRequestConfirmations, callbackGasLimit, numWords)] = Request({
            requestId: requestId,
            from: RandomConsumer(msg.sender),
            chances: chances
        });
        _nextRequestId.increment();
    }
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        Request storage request = _requests[requestId];
        uint word = randomWords[0];
        Fees.Fee[] storage chances = request.chances;
        uint len = chances.length;
        bool[] memory results = new bool[](len);
        for(uint i; i < len; i ++) {
            Fees.Fee storage chance = chances[i];
            results[i] = word % chance.denominator < chance.numerator;
            word = _newWord(word);
        }
        request.from.rawFulFillRandom(request.requestId, results);
    }
    function _newWord(uint word) private pure returns(uint) {
        return uint(sha256(abi.encode(word)));
    }

}

