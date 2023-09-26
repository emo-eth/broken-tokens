// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721} from "solady/tokens/ERC721.sol";
import {LibString} from "solady/strings/LibString.sol";

contract BrokenToken is ERC721 {
    uint256 nextTokenId = 1;

    error Soulbound();

    enum Status {
        OK,
        SOULBOUND,
        CUSTOM_STRING
    }

    mapping(uint256 tokenId => string customRevertString) public customRevertStrings;

    function name() public pure override returns (string memory) {
        return "BrokenToken";
    }

    function symbol() public pure override returns (string memory) {
        return "BROKEN";
    }

    function tokenURI(uint256 id) public pure override returns (string memory) {
        return string.concat("https://example.com/", LibString.toString(id));
    }

    function mint() public {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
    }

    function mintSoulbound() public {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        _setExtraData(tokenId, uint96(uint8(Status.SOULBOUND)));
    }

    function mintCustomRevertString(string calldata customRevertString) public {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        customRevertStrings[tokenId] = customRevertString;
        _setExtraData(tokenId, uint96(uint8(Status.CUSTOM_STRING)));
    }

    function _beforeTokenTransfer(address, address, uint256 id) internal pure override {
        Status status = Status(uint8(_getExtraData(id)));
        if (status == Status.SOULBOUND) {
            revert Soulbound();
        } else if (status == Status.CUSTOM_STRING) {
            revert(customRevertStrings[id]);
        }
    }
}