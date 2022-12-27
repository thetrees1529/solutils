//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
interface IRandom {

    function numWords() external view returns(uint32);
    function CONSUMER_ROLE() external view returns(bytes32);

    function vrfConfig() external view returns(bytes32,uint64,uint16,uint32);
    function vrfCoordinator() external view returns(VRFCoordinatorV2Interface);

    function requestRandom(uint[] calldata options) external returns(uint requestId);

}


