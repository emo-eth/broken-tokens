// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {BrokenToken} from "src/./BrokenToken.sol";

contract BrokenTokenTest is Test {
    BrokenToken token;

    function setUp() public {
        token = new BrokenToken();
    }
}
