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

    function mint() external {
        _safeMint(msg.sender, _tokenId._value);
        _tokenId.decrement();
    }

    function getTokenId() external returns (uint256) {
        return _tokenId._value;
    }

    function getSpecialItems() external returns (uint256 total) {
        uint256 lastIndex = balanceOf(msg.sender);
        for (uint256 i = 0; i < lastIndex;) {
            unchecked {
                uint256 token = tokenOfOwnerByIndex(msg.sender, i);
                if (_isPrime(token)) {
                    total++;
                }
                ++i;
            }
        }
        return total;
    }

    function _isPrime(uint256 x) internal pure returns (bool) {
        if (x == 1) return false;
        if (x < 3) return true;
        for (uint256 i = 2; i < x / 2 + 1;) {
            unchecked {
                if (x % i == 0) return false;
                ++i;
            }
        }
        return true;
    }
}
