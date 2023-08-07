// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {Ownable2Step} from "@openzeppelin/access/Ownable2Step.sol";

contract ERC20Reward is ERC20, Ownable2Step {
    event Mint(address account, uint256 amount);

    constructor(address stakeOperator) ERC20("Stake Reward", "SRWD") {
        transferOwnership(stakeOperator);
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
        emit Mint(account, amount);
    }
}
