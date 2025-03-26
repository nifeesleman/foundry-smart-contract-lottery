//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfirg} from "script/HelperConfirg.s.sol";

contract DeployRaffle is Script {
    function run() public {}

    function deployContract() public returns (Raffle, HelperConfirg) {
        HelperConfirg helperConfirg = new HelperConfirg();
        //local -> deploy mocks ,get local config
        //seploia -> get seploia config
        HelperConfirg.NetworkConfig memory config = helperConfirg.getConfig();
        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordnator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        return (raffle, helperConfirg);
    }
}
