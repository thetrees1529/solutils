//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "./IRandom.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {IRandomConsumer} from "./IRandomConsumer.sol";
contract Random is IRandom, VRFConsumerBaseV2, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _nextRequestId;
    uint32 public constant numWords = 1;
    bytes32 public constant CONSUMER_ROLE = keccak256("CONSUMER_ROLE");
    struct VrfConfig {
        bytes32 keyHash;
        uint64 subId;
        uint16 minimumRequestConfirmations;
        uint32 callbackGasLimit;
    }
    VrfConfig public vrfConfig;
    constructor(VRFCoordinatorV2Interface vrfCoordinator_, VrfConfig memory vrfConfig_) VRFConsumerBaseV2(address(vrfCoordinator_)) {
        vrfCoordinator = vrfCoordinator_;
        vrfConfig = vrfConfig_;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    VRFCoordinatorV2Interface public vrfCoordinator;
    struct Request {
        uint requestId;
        IRandomConsumer from;
        uint[] options;
        uint total;
    }
    mapping(uint => Request) private _requests;

    function requestRandom(uint[] calldata options) external onlyRole(CONSUMER_ROLE) returns(uint requestId) {
        requestId = _nextRequestId.current();
        _nextRequestId.increment();
        uint total;
        for(uint i; i < options.length; i ++) total += options[i];
        require(total > 0, "Must have at least 1 weighting.");
        _requests[vrfCoordinator.requestRandomWords(vrfConfig.keyHash, vrfConfig.subId, vrfConfig.minimumRequestConfirmations, vrfConfig.callbackGasLimit, numWords)] = Request({
            requestId: requestId,
            from: IRandomConsumer(msg.sender),
            options: options,
            total: total
        });
    }
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        Request storage request = _requests[requestId];
        uint word = randomWords[0];
        uint[] storage options = request.options;
        uint len = options.length;
        uint total = request.total;
        for(uint i; i < len; i ++) {
            uint option = options[i];
            uint r = word % total;
            if(r < option) return request.from.rawFulFillRandom(request.requestId, i); 
            total -= option;
            word = uint(sha256(abi.encode(word)));
        }
    }



}

