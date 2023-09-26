// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {LibString} from "solady/utils/LibString.sol";
import {ERC721ConduitPreapproved_Solady} from "shipyard-core/tokens/erc721/ERC721ConduitPreapproved_Solady.sol";

contract BrokenToken is ERC721ConduitPreapproved_Solady {
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

    function mint(address recipient) public {
        _mint(recipient);
    }

    function mintSoulbound(address recipient) public {
        uint256 tokenId = _mint(recipient);
        _setExtraData(tokenId, uint96(uint8(Status.SOULBOUND)));
    }

    function mintCustomRevertString(address recipient, string calldata customRevertString) public {
        uint256 tokenId = _mint(recipient);
        customRevertStrings[tokenId] = customRevertString;
        _setExtraData(tokenId, uint96(uint8(Status.CUSTOM_STRING)));
    }

    function _mint(address recipient) internal returns (uint256 tokenId) {
        tokenId = nextTokenId++;
        _mint(recipient, tokenId);
    }

    function _beforeTokenTransfer(address, address, uint256 id) internal view override {
        Status status = Status(uint8(_getExtraData(id)));
        if (status == Status.SOULBOUND) {
            revert Soulbound();
        } else if (status == Status.CUSTOM_STRING) {
            revert(customRevertStrings[id]);
        }
    }
}
