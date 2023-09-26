// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {BrokenToken} from "../src/BrokenToken.sol";
import {BaseCreate2Script} from "create2-helpers/BaseCreate2Script.s.sol";

contract DeployBrokenToken is BaseCreate2Script {
    function run() public {
        _create2IfNotDeployed(deployer, bytes32(0), type(BrokenToken).creationCode);
    }
}
