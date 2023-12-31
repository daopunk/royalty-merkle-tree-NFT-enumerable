// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {ERC2981} from "@openzeppelin/token/common/ERC2981.sol";
import {MerkleProof} from "@openzeppelin/utils/cryptography/MerkleProof.sol";
import {Ownable2Step} from "@openzeppelin/access/Ownable2Step.sol";
import {BitMaps} from "@openzeppelin/utils/structs/BitMaps.sol";
import {Counters} from "@openzeppelin/utils/Counters.sol";

contract ERC721Staking is ERC721, ERC2981, Ownable2Step {
    using Counters for Counters.Counter;
    using BitMaps for BitMaps.BitMap;

    Counters.Counter private _tokenId;
    BitMaps.BitMap private _bitmap;

    uint256 public constant PRICE = 10 ether;
    bytes32 private immutable _merkleRoot;

    constructor(bytes32 merkleroot) payable ERC721("Trio", "TRIO") {
        _setDefaultRoyalty(address(this), 250);
        _merkleRoot = merkleroot;
        _tokenId._value = 20;
    }

    function publicMint() external payable {
        require(msg.value == PRICE, "Incorrect price");
        _pMint(msg.sender);
    }

    function privateMint(bytes32[] calldata merkleProof, uint256 ticket) external payable {
        require(msg.value == PRICE / 5, "Incorrect price");
        _validateMerkleTree(merkleProof, ticket);
        _pMint(msg.sender);
    }

    function withdraw() external onlyOwner {
        uint256 payout = address(this).balance;
        require(payout > 0, "No funds available");
        (bool success,) = msg.sender.call{value: payout}("");
        require(success, "Withdraw error");
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return (ERC721.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId));
    }

    function _pMint(address owner) internal {
        uint256 tokenId = _tokenId.current();
        require(tokenId > 0, "Mint empty");
        _safeMint(owner, tokenId);
        _tokenId.decrement();
    }

    function _validateMerkleTree(bytes32[] calldata merkleProof, uint256 ticket) internal {
        // user allowed only 1 mint at discount
        require(!_bitmap.get(ticket), "Ticket already used");

        // if valid Merkle proof, user can mint
        require(
            MerkleProof.verify(merkleProof, _merkleRoot, keccak256(abi.encodePacked(msg.sender, ticket))),
            "Invalid proof"
        );

        // mark user discount mint as expired
        _bitmap.set(ticket);
    }
}
