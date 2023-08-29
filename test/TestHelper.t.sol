// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "lib/forge-std/src/console.sol";

import {ERC20Reward} from "src/staking/ERC20Reward.sol";
import {ERC721Staking} from "src/staking/ERC721Staking.sol";
import {StakeOperator} from "src/staking/StakeOperator.sol";
import {ERC721EnumPlayer} from "src/ERC721EnumPlayer.sol";
import {MerkleTreeGenerator} from "src/utils/MerkleTreeGenerator.sol";

// forge t --gas-report

contract TestHelper is Test {
    MerkleTreeGenerator public merkleTree;
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

    address[6] public airdropList = [alice, bob, cobra, dede, edde, fefe];
    uint256[6] public tickets = [1, 2, 3, 4, 5, 6];

    // root
    bytes32 public merkleroot;
    bytes32[] _hashedLeaves;
    bytes32[] _tree;

    // leaves
    bytes32 public abHash;
    bytes32 public cdHash;
    bytes32 public efHash;
    bytes32 public abcdHash;

    function setUp() public {
        merkleTree = new MerkleTreeGenerator();

        bytes32[] memory leaves = new bytes32[](6);
        leaves[0] = keccak256(abi.encodePacked(airdropList[0], tickets[0]));
        leaves[1] = keccak256(abi.encodePacked(airdropList[1], tickets[1]));
        leaves[2] = keccak256(abi.encodePacked(airdropList[2], tickets[2]));
        leaves[3] = keccak256(abi.encodePacked(airdropList[3], tickets[3]));
        leaves[4] = keccak256(abi.encodePacked(airdropList[4], tickets[4]));
        leaves[5] = keccak256(abi.encodePacked(airdropList[5], tickets[5]));

        bytes memory payload = abi.encodeWithSignature("generateMerkleTree(bytes32[])", leaves);
        (bool success, bytes memory data) = address(merkleTree).call(payload);
        require(success, "Payload fail");

        _tree = abi.decode(data, (bytes32[]));
        merkleroot = _tree[0];
        require(merkleroot == validateMerkleRoot(), "merkleroot check fail");

        erc721Staking = new ERC721Staking(merkleroot);
        stakeOperator = new StakeOperator(address(erc721Staking));
        erc20Reward = new ERC20Reward(address(stakeOperator));
        erc721EnumPlayer = new ERC721EnumPlayer();

        stakeOperator.setERC20Reward(address(erc20Reward));

        mintEther();
    }

    function getProof(uint256 index) public view returns (bytes32[] memory) {
        return merkleTree.getProof(_tree, index);
    }

    function mintEther() public {
        vm.deal(alice, 10000 ether);
        vm.deal(bob, 10000 ether);
        vm.deal(cobra, 10000 ether);
        vm.deal(dede, 10000 ether);
    }

    function validateMerkleRoot() public returns (bytes32 root) {
        bytes32 aHash = keccak256(abi.encodePacked(alice, uint256(1)));
        bytes32 bHash = keccak256(abi.encodePacked(bob, uint256(2)));
        bytes32 cHash = keccak256(abi.encodePacked(cobra, uint256(3)));
        bytes32 dHash = keccak256(abi.encodePacked(dede, uint256(4)));
        bytes32 eHash = keccak256(abi.encodePacked(edde, uint256(5)));
        bytes32 fHash = keccak256(abi.encodePacked(fefe, uint256(6)));

        if (aHash < bHash) {
            abHash = keccak256(abi.encodePacked(bytes.concat(aHash, bHash)));
        } else {
            abHash = keccak256(abi.encodePacked(bytes.concat(bHash, aHash)));
        }

        if (cHash < dHash) {
            cdHash = keccak256(abi.encodePacked(bytes.concat(cHash, dHash)));
        } else {
            cdHash = keccak256(abi.encodePacked(bytes.concat(dHash, cHash)));
        }

        if (eHash < fHash) {
            efHash = keccak256(abi.encodePacked(bytes.concat(eHash, fHash)));
        } else {
            efHash = keccak256(abi.encodePacked(bytes.concat(fHash, eHash)));
        }

        if (abHash < cdHash) {
            abcdHash = keccak256(abi.encodePacked(bytes.concat(abHash, cdHash)));
        } else {
            abcdHash = keccak256(abi.encodePacked(bytes.concat(cdHash, abHash)));
        }

        if (abcdHash < efHash) {
            root = keccak256(abi.encodePacked(bytes.concat(abcdHash, efHash)));
        } else {
            root = keccak256(abi.encodePacked(bytes.concat(efHash, abcdHash)));
        }
    }
}
