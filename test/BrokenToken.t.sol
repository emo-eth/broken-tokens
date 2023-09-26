// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {BrokenToken} from "../src/BrokenToken.sol";

contract BrokenTokenTest is Test {
    BrokenToken token;

    address CONDUIT = 0x1E0049783F008A0085193E00003D00cd54003c71;

    function setUp() public {
        token = new BrokenToken();
    }

    function test_mint() public {
        token.mint(address(this));
        assertEq(token.balanceOf(address(this)), 1);
        assertEq(token.ownerOf(1), address(this));
        token.transferFrom(address(this), address(0xdead), 1);
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(0xdead)), 1);
        assertEq(token.ownerOf(1), address(0xdead));
    }

    function test_sequentialIds() public {
        token.mint(address(this));
        token.mintSoulbound(address(this));
        token.mintCustomRevertString(address(this), "custom revert string");
        assertEq(token.balanceOf(address(this)), 3);
        assertEq(token.ownerOf(1), address(this));
        assertEq(token.ownerOf(2), address(this));
        assertEq(token.ownerOf(3), address(this));
        token.transferFrom(address(this), address(0xdead), 1);
        vm.expectRevert(BrokenToken.Soulbound.selector);
        token.transferFrom(address(this), address(0xdead), 2);
        vm.expectRevert(bytes("custom revert string"));
        token.transferFrom(address(this), address(0xdead), 3);
    }

    function test_mintSoulbound() public {
        token.mintSoulbound(address(this));
        assertEq(token.balanceOf(address(this)), 1);
        assertEq(token.ownerOf(1), address(this));
        vm.expectRevert(BrokenToken.Soulbound.selector);
        token.transferFrom(address(this), address(0xdead), 1);
    }

    function test_mintCustomError(string memory revertString) public {
        token.mintCustomRevertString(address(this), revertString);
        assertEq(token.balanceOf(address(this)), 1);
        assertEq(token.ownerOf(1), address(this));
        vm.expectRevert(bytes(revertString));
        token.transferFrom(address(this), address(0xdead), 1);
    }

    function test_mintRecipient() public {
        token.mint(address(0xdead));
        token.mintSoulbound(address(0xdead));
        token.mintCustomRevertString(address(0xdead), "custom revert string");
        assertEq(token.balanceOf(address(0xdead)), 3);
        assertEq(token.ownerOf(1), address(0xdead));
        assertEq(token.ownerOf(2), address(0xdead));
        assertEq(token.ownerOf(3), address(0xdead));
    }

    function testConduitPreapproval() public {
        token.mint(address(this));
        vm.prank(CONDUIT);
        token.transferFrom(address(this), address(0xdead), 1);
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(0xdead)), 1);
        assertEq(token.ownerOf(1), address(0xdead));
    }
}
