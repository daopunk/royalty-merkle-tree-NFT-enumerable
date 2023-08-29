// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {TestHelper} from "test/TestHelper.t.sol";

contract StakingTrio is TestHelper {
    function testPublicMint() public {
        vm.startPrank(alice);
        erc721Staking.publicMint{value: 10 ether}();
        assertEq(erc721Staking.balanceOf(alice), 1);
        vm.stopPrank();
    }

    function testPrivateMint() public {
        bytes32[] memory proofAlice = getProof(10);
        bytes memory payloadAlice = abi.encodeWithSignature("privateMint(bytes32[],uint256)", proofAlice, 1);

        vm.startPrank(alice);
        (bool successAlice,) = address(erc721Staking).call{value: 2 ether, gas: 1000000}(payloadAlice);
        require(successAlice, "Payload fail");

        (bool successAliceDoubleMint,) = address(erc721Staking).call{value: 2 ether, gas: 1000000}(payloadAlice);
        require(!successAliceDoubleMint, "Payload success");

        assertEq(erc721Staking.balanceOf(alice), 1);
        vm.stopPrank();

        bytes32[] memory proofDede = getProof(7);
        bytes memory payloadDede = abi.encodeWithSignature("privateMint(bytes32[],uint256)", proofDede, 4);

        vm.startPrank(dede);
        (bool successDede,) = address(erc721Staking).call{value: 2 ether, gas: 1000000}(payloadDede);
        require(successDede, "Payload fail");
        assertEq(erc721Staking.balanceOf(dede), 1);
        vm.stopPrank();
    }

    function testStakingAndReward() public {
        uint256 startTime = block.timestamp;
        vm.startPrank(alice);
        erc721Staking.publicMint{value: 10 ether}();
        assertEq(erc721Staking.balanceOf(alice), 1);
        vm.stopPrank();

        vm.startPrank(bob);
        erc721Staking.publicMint{value: 10 ether}();
        erc721Staking.publicMint{value: 10 ether}();
        assertEq(erc721Staking.balanceOf(bob), 2);
        vm.stopPrank();

        vm.startPrank(alice);
        erc721Staking.approve(address(stakeOperator), 20);
        erc721Staking.safeTransferFrom(alice, address(stakeOperator), 20);
        assertEq(erc721Staking.balanceOf(address(stakeOperator)), 1);
        assertEq(erc721Staking.balanceOf(alice), 0);

        vm.expectRevert("StakeOperator: Claim not eligible yet");
        stakeOperator.claimReward(20);

        vm.warp(startTime + 1 days + 1 minutes);
        stakeOperator.claimReward(20);

        assertEq(erc721Staking.balanceOf(address(stakeOperator)), 0);
        assertEq(erc721Staking.balanceOf(alice), 1);

        assertEq(erc20Reward.balanceOf(alice), 10 ether);
        vm.stopPrank();

        vm.startPrank(bob);
        vm.stopPrank();
    }

    function testOwnerWithdraw() public {
        emit log_address(erc721Staking.owner());

        vm.expectRevert("No funds available");
        erc721Staking.withdraw();
    }

    function testRewardToken() public {
        assertEq(address(stakeOperator.tokenReward()), address(erc20Reward));
    }
}
