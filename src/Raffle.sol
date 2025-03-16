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
    error Raffle__NotEnoughEthSent();

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /**
     * Events
     */
    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // require(msg.value == entranceFee, "Not enough ETH sent !");
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);
    }

    //1. Get a random number
    //2. Use random nuber to pick winner
    //3. Be automaticlly called
    function pickWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }
    }

    /**
     * Getting Function
     */
    function getEnteranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
