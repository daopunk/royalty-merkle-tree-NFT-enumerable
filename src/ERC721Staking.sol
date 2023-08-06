// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ERC721 is  {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
