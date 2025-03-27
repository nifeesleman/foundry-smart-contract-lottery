//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function CreateSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordnator = helperConfig.getConfig().vrfCoordnator;

        (uint256 subId, ) = createSubscription(vrfCoordnator);
        return (subId, vrfCoordnator);
    }

    function createSubscription(
        address vrfCoordnator
    ) public returns (uint256, address) {
        console.log("Creating subscribtion on chain id", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordnator)
            .createSubscription();
        vm.stopBroadcast();
        console.log("your subscription id is :", subId);
        console.log(
            "Please update the subscription Id in your Helperconfig.s.sol"
        );
        return (subId, vrfCoordnator);
    }

    function run() public {
        CreateSubscriptionUsingConfig();
    }
}
