//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig, CodeContrants} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

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

contract FundSubscription is Script, CodeContrants {
    uint256 public constant FUND_AMOUNT = 3 ether;

    function fundSubscriptionUingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordnator = helperConfig.getConfig().vrfCoordnator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        fundSubscription(vrfCoordnator, subscriptionId, linkToken);
    }

    function fundSubscription(
        address vrfcoordnator,
        uint256 subscriptionId,
        address linkToken
    ) public {
        console.log("Funding Subscription Id :", subscriptionId);
        console.log("Using vrfCoordnator :", vrfcoordnator);
        console.log("On Chainid :", block.chainid);

        if (block.chainid == LOCAL_CHAIN_ID) {
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfcoordnator).fundSubscription(
                subscriptionId,
                FUND_AMOUNT * 100
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(linkToken).transferAndCall(
                vrfcoordnator,
                FUND_AMOUNT,
                abi.encode(subscriptionId)
            );
            vm.stopBroadcast();
        }
    }

    function run() public {
        fundSubscriptionUingConfig();
    }
}

contract AddConsumer is Script {
    function addConsumerUsingConfig(address mostRecentlyDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        uint256 subId = helperConfig.getConfig().subscriptionId;
        address vrfCoordnator = helperConfig.getConfig().vrfCoordnator;
        addConsumer(mostRecentlyDeployed, vrfCoordnator, subId);
    }

    function addConsumer(
        address contractToAddtoVrf,
        address vrfCoodnate,
        uint subscriptionId
    ) public {
        console.log("Adding consumer contract :", contractToAddtoVrf);
        console.log("To vrfCoordinator :", vrfCoodnate);
        console.log("On chianId : ", block.chainid);
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(vrfCoodnate).addConsumer(
            subscriptionId,
            contractToAddtoVrf
        );

        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Raffel",
            block.chainid
        );
        addConsumerUsingConfig(mostRecentlyDeployed);
    }
}
