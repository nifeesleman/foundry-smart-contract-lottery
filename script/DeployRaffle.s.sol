//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "script/interactions.s.sol";

contract DeployRaffle is Script {
    function run() public {
        deployContract();
    }

    function deployContract() public returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        //local -> deploy mocks ,get local config
        //seploia -> get seploia config
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        if (config.subscriptionId == 0) {
            //create subscription
            CreateSubscription createSubscription = new CreateSubscription();
            (config.subscriptionId, config.vrfCoordnator) =
                createSubscription.createSubscription(config.vrfCoordnator, config.account);

            //Fund it !
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(config.vrfCoordnator, config.subscriptionId, config.link, config.account);
        }
        vm.startBroadcast(config.account);
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordnator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(address(raffle), config.vrfCoordnator, config.subscriptionId, config.account);

        return (raffle, helperConfig);
    }
}
