// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ERC20Reward} from "src/staking/ERC20Reward.sol";
import {ERC721Staking} from "src/staking/ERC721Staking.sol";
import {StakeOperator} from "src/staking/StakeOperator.sol";
import {ERC721EnumPlayer} from "src/ERC721EnumPlayer.sol";

contract TestHelper is Test {
    ERC20Reward public erc20Reward;
    ERC721Staking public erc721Staking;
    StakeOperator public stakeOperator;
    ERC721EnumPlayer public erc721EnumPlayer;

    bytes32 _merkleroot = bytes32(1);

    function setUp() public {
        erc721Staking = new ERC721Staking(merkleroot);
        stakeOperator = new StakeOperator(address(erc721Staking));
        erc20Reward = new ERC20Reward(address(stakeOperator));
        erc721EnumPlayer = new ERC721EnumPlayer();
    }
}
