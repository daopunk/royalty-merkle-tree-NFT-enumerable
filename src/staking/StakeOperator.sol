// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721Receiver} from "@openzeppelin/token/ERC721/IERC721Receiver.sol";
import {IERC721} from "@openzeppelin/token/ERC721/IERC721.sol";
import {Ownable2Step} from "@openzeppelin/access/Ownable2Step.sol";

interface IERC20Reward {
    function mint(address account, uint256 amount) external;
}

contract StakeOperator is IERC721Receiver, Ownable2Step {
    IERC20Reward public tokenReward;
    IERC721 public nftStaking;

    struct Claim {
        uint256 timeLock;
        uint256 dailyClaim;
        uint256 retrieval;
    }

    mapping(address owner => mapping(uint256 tokenId => Claim)) public staked;

    event RecieveNFT(address operator, address from, uint256 tokenId);

    constructor(address _nftStaking) {
        nftStaking = IERC721(_nftStaking);
    }

    function setERC20Reward(address _tokenReward) external onlyOwner {
        tokenReward = IERC20Reward(_tokenReward);
    }

    function claimReward(uint256 tokenId) external {
        Claim memory claim = staked[msg.sender][tokenId];
        require(claim.dailyClaim > 0, "StakeOperator: Already claimed");
        require(claim.timeLock < block.timestamp, "StakeOperator: Claim not eligible yet");

        // TODO: can use `claim` variable or will that not write to storage?
        staked[msg.sender][tokenId].dailyClaim = 0;
        staked[msg.sender][tokenId].timeLock = 0;
        tokenReward.mint(msg.sender, 10 ether);
    }

    function claimNft(uint256 tokenId) external {
        require(staked[msg.sender][tokenId].retrieval == 1, "StakeOperator: Already retrieved");
        staked[msg.sender][tokenId].retrieval = 0;
        nftStaking.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    // TODO: this does not work
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        // require(msg.sender == address(nftStaking), "StakeOperator: Wrong staking asset");
        require(msg.sender == address(999), "StakeOperator: Wrong staking asset");

        // staked[from][tokenId] = Claim(block.timestamp + 1 days, 1, 1);
        // staked[from][tokenId].timelock = block.timestamp + 1 days;
        // staked[from][tokenId].dailyClaim = 1;
        // staked[from][tokenId].retrieval = 1;
        emit RecieveNFT(operator, from, tokenId);

        Claim memory c = Claim(block.timestamp + 1 days, uint256(1), 1);
        staked[from][tokenId] = c;

        return IERC721Receiver.onERC721Received.selector;
    }
}
