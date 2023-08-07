// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ERC20Reward} from "src/staking/ERC20Reward.sol";
import {ERC721Staking} from "src/staking/ERC721Staking.sol";
import {StakeOperator} from "src/staking/StakeOperator.sol";
import {ERC721EnumPlayer} from "src/ERC721EnumPlayer.sol";

// forge t --gas-report

contract TestHelper is Test {
    ERC20Reward public erc20Reward;
    ERC721Staking public erc721Staking;
    StakeOperator public stakeOperator;
    ERC721EnumPlayer public erc721EnumPlayer;

    address public alice = address(0xa11ce);
    address public bob = address(0xb0b);
    address public cobra = address(0xc0b7a);

    bytes32 _merkleroot = bytes32(uint256(0));

    function setUp() public {
        erc721Staking = new ERC721Staking(_merkleroot);
        stakeOperator = new StakeOperator(address(erc721Staking));
        erc20Reward = new ERC20Reward(address(stakeOperator));
        erc721EnumPlayer = new ERC721EnumPlayer();

        mintEther();
    }

    function mintEther() public {
        vm.deal(alice, 10000 ether);
        vm.deal(bob, 10000 ether);
        vm.deal(cobra, 10000 ether);
    }
}
