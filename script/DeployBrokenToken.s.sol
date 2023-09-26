// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {BrokenToken} from "../src/BrokenToken.sol";

contract DeployBrokenToken is Script {
    function run() public {
        address deployer = vm.envAddress("DEPLOYER");
        vm.broadcast(deployer);
        // Deploy the contract
        new BrokenToken();
    }
}
