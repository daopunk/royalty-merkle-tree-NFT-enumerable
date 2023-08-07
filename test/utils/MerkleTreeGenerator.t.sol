// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract MerkleTreeGenerator is Test {
    bytes32[] public nodes;

    function generate6(address[6] memory airdropList, uint256[6] memory tickets) public returns (bytes32) {
        uint256 l = airdropList.length;
        require(l == tickets.length, "MerkleTreeGenerator: Lengths are different");

        // hash leaves
        for (uint256 i = 0; i < l; i++) {
            bytes32 hashed = keccak256(abi.encodePacked(airdropList[i], tickets[i]));
            nodes.push(hashed);
        }
        uint256 offset = 0;

        while (l > 0) {
            if (l % 2 != 0) {
                uint256 ll = l - 1;
                uint256 i = 0;
                while (i < ll) {
                    bytes32 hashed = keccak256(abi.encodePacked(nodes[offset + i], nodes[offset + i + 1]));

                    nodes.push(hashed);
                    i += 2;
                }
                nodes.push(nodes[offset + i + 1]);
            } else {
                for (uint256 i = 0; i < l; i += 2) {
                    bytes32 hashed = keccak256(abi.encodePacked(nodes[offset + i], nodes[offset + i + 1]));

                    nodes.push(hashed);
                }
            }
            offset += l;
            l = l / 2;
        }

        uint256 nodesLength = nodes.length;

        if (nodesLength % 2 == 0) {
            uint256 x = nodesLength - 3;
            uint256 y = nodesLength - 4;

            return keccak256(abi.encodePacked(nodes[x], nodes[y]));
        }

        return nodes[nodesLength - 1];
    }

    // function generate5(address[5] memory airdropList, uint256[5] memory tickets) public returns (bytes32) {
    //     uint256 l = airdropList.length;
    //     require(l == tickets.length, "MerkleTreeGenerator: Lengths are different");

    //     // hash leaves
    //     for (uint256 i = 0; i < l; i++) {
    //         bytes32 hashed = keccak256(abi.encodePacked(airdropList[i], tickets[i]));
    //         nodes.push(hashed);
    //     }
    //     uint256 offset = 0;

    //     while (l > 0) {
    //         if (l % 2 != 0) {
    //             uint256 ll = l - 1;
    //             uint256 i = 0;
    //             while (i < ll) {
    //                 bytes32 hashed = keccak256(abi.encodePacked(nodes[offset + i], nodes[offset + i + 1]));

    //                 nodes.push(hashed);
    //                 i += 2;
    //             }
    //             nodes.push(nodes[offset + i + 1]);
    //         } else {
    //             for (uint256 i = 0; i < l; i += 2) {
    //                 bytes32 hashed = keccak256(abi.encodePacked(nodes[offset + i], nodes[offset + i + 1]));

    //                 nodes.push(hashed);
    //             }
    //         }
    //         offset += l;
    //         l = l / 2;
    //     }

    //     uint256 nodesLength = nodes.length;

    //     if (nodesLength % 2 == 0) {
    //         uint256 x = nodesLength - 3;
    //         uint256 y = nodesLength - 4;

    //         return keccak256(abi.encodePacked(nodes[x], nodes[y]));
    //     }

    //     return nodes[nodesLength - 1];
    // }

    function generate4(address[4] memory airdropList, uint256[4] memory tickets) public returns (bytes32) {
        uint256 l = airdropList.length;
        require(l == tickets.length, "MerkleTreeGenerator: Lengths are different");

        // hash leaves
        for (uint256 i = 0; i < l; i++) {
            bytes32 hashed = keccak256(abi.encodePacked(airdropList[i], tickets[i]));
            nodes.push(hashed);
        }
        uint256 offset = 0;

        while (l > 0) {
            for (uint256 i = 0; i < l; i += 2) {
                bytes32 hashed = keccak256(abi.encodePacked(nodes[offset + i], nodes[offset + i + 1]));

                nodes.push(hashed);
            }
            offset += l;
            l = l / 2;
        }

        uint256 nodesLength = nodes.length;

        return nodes[nodesLength - 1];
    }
}
