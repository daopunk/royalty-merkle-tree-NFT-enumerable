// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TestHelper} from "test/TestHelper.t.sol";

contract StakingTrio is TestHelper {
    function testPublicMint() public {
        vm.startPrank(alice);
        erc721Staking.publicMint{value: 10 ether}();
        assertEq(erc721Staking.balanceOf(alice), 1);
        vm.stopPrank();
    }

    // TODO: why is proof failing?
    function testPrivateMint() public {
        bytes32 aHash = keccak256(abi.encodePacked(alice, uint256(1)));
        bytes32 bHash = keccak256(abi.encodePacked(bob, uint256(2)));
        bytes32 cHash = keccak256(abi.encodePacked(cobra, uint256(3)));
        bytes32 dHash = keccak256(abi.encodePacked(dede, uint256(4)));
        bytes32 eHash = keccak256(abi.encodePacked(edde, uint256(5)));
        bytes32 fHash = keccak256(abi.encodePacked(fefe, uint256(6)));

        // bytes32 abHash = keccak256(abi.encodePacked(aHash, bHash));
        bytes32 cdHash = keccak256(abi.encodePacked(cHash, dHash));
        bytes32 efHash = keccak256(abi.encodePacked(eHash, fHash));

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = aHash;
        proof[1] = bHash;
        proof[2] = cdHash;
        proof[3] = efHash;

        bytes memory payload = abi.encodeWithSignature("privateMint(bytes32[],uint256)", proof, 1);

        vm.startPrank(alice);
        (bool success,) = address(erc721Staking).call{value: 2 ether, gas: 1000000}(payload);
        require(success, "Payload fail");
        assertEq(erc721Staking.balanceOf(alice), 1);
        vm.stopPrank();
    }

    function testStakingAndReward() public {}
}
