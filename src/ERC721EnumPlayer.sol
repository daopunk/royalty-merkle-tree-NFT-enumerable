// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721Enumerable} from "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";

contract ERC721EnumPlayer is ERC721Enumerable {
    constructor() ERC721("Player", "PLYR") {}
}
