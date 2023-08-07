// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721Enumerable} from "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/utils/Counters.sol";

contract ERC721EnumPlayer is ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenId;

    constructor() ERC721("Player", "PLYR") {
        _tokenId._value = 20;
    }

    function getSpecialItems() external returns (uint256 total) {
        uint256 indexLength = balanceOf(msg.sender) + 1;
        for (uint256 i = 0; i < indexLength; i++) {
            uint256 token = tokenOfOwnerByIndex(msg.sender, i);
            if (_simpleIsPrime(token)) {
                total++;
            }
        }
        return total;
    }

    function _simpleIsPrime(uint256 x) internal returns (bool) {
        if (x == 1) return false;
        if (x < 3) return true;
        for (uint256 i = 2; i < x; i++) {
            if (x % i == 0) return false;
        }
        return true;
    }
}

// forge t --gas-report

contract TestThis {
    function _simpleIsPrime(uint256 x) internal returns (bool) {
        if (x < 3) return 2;
        for (uint256 i = 2; i < x; i++) {
            if (x % i == 0) return false;
        }
        return true;
    }
}
