// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title A Raffle contract
 * @author Nife Esleman
 * @notice This contract is for creating a sample raffle
 * @dev Implementing Chainlink VRFv2
 */
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle(uint256 entranceFee) public payable {
        require(msg.value == entranceFee, "Not enough ETH sent !");
    }

    function pickWinner() public {}

    /**Getting Function */
    function getEnteranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
