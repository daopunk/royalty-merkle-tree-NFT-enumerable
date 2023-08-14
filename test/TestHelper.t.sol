// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ERC20Reward} from "src/staking/ERC20Reward.sol";
import {ERC721Staking} from "src/staking/ERC721Staking.sol";
import {StakeOperator} from "src/staking/StakeOperator.sol";
import {ERC721EnumPlayer} from "src/ERC721EnumPlayer.sol";
import {MerkleTreeGenerator} from "test/utils/MerkleTreeGenerator.t.sol";

// forge t --gas-report

contract TestHelper is Test, MerkleTreeGenerator {
    ERC20Reward public erc20Reward;
    ERC721Staking public erc721Staking;
    StakeOperator public stakeOperator;
    ERC721EnumPlayer public erc721EnumPlayer;

    address public alice = address(0xa11ce);
    address public bob = address(0xb0b);
    address public cobra = address(0xc0b7a);
    address public dede = address(0xdede);
    address public edde = address(0xedde);
    address public fefe = address(0xfefe);

    address[4] public airdropList4 = [alice, bob, cobra, dede];
    uint256[4] public tickets4 = [1, 2, 3, 4];
    address[6] public airdropList6 = [alice, bob, cobra, dede, edde, fefe];
    uint256[6] public tickets6 = [1, 2, 3, 4, 5, 6];

    bytes32 public merkleroot;

    function setUp() public {
        // merkleroot = generate6(airdropList6, tickets6);

        erc721Staking = new ERC721Staking(merkleroot);
        stakeOperator = new StakeOperator(address(erc721Staking));
        erc20Reward = new ERC20Reward(address(stakeOperator));
        erc721EnumPlayer = new ERC721EnumPlayer();

        mintEther();

        // assertEq(generate6(airdropList6, tickets6), validateMerkleRoot6());
        // assertEq(generate4(airdropList4, tickets4), validateMerkleRoot4());
    }

    function mintEther() public {
        vm.deal(alice, 10000 ether);
        vm.deal(bob, 10000 ether);
        vm.deal(cobra, 10000 ether);
    }

    function validateMerkleRoot4() public returns (bytes32 root) {
        bytes32 aHash = keccak256(abi.encodePacked(alice, uint256(1)));
        bytes32 bHash = keccak256(abi.encodePacked(bob, uint256(2)));
        bytes32 cHash = keccak256(abi.encodePacked(cobra, uint256(3)));
        bytes32 dHash = keccak256(abi.encodePacked(dede, uint256(4)));

        bytes32 abHash = keccak256(abi.encodePacked(aHash, bHash));
        bytes32 cdHash = keccak256(abi.encodePacked(cHash, dHash));
        root = keccak256(abi.encodePacked(abHash, cdHash));
    }

    function validateMerkleRoot6() public returns (bytes32 root) {
        bytes32 aHash = keccak256(abi.encodePacked(alice, uint256(1)));
        bytes32 bHash = keccak256(abi.encodePacked(bob, uint256(2)));
        bytes32 cHash = keccak256(abi.encodePacked(cobra, uint256(3)));
        bytes32 dHash = keccak256(abi.encodePacked(dede, uint256(4)));
        bytes32 eHash = keccak256(abi.encodePacked(edde, uint256(5)));
        bytes32 fHash = keccak256(abi.encodePacked(fefe, uint256(6)));

        bytes32 abHash = keccak256(abi.encodePacked(aHash, bHash));
        bytes32 cdHash = keccak256(abi.encodePacked(cHash, dHash));
        bytes32 efHash = keccak256(abi.encodePacked(eHash, fHash));

        bytes32 abcdHash = keccak256(abi.encodePacked(abHash, cdHash));
        root = keccak256(abi.encodePacked(abcdHash, efHash));
    }
}
