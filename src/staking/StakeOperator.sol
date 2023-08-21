// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// no carrot ^

import {IERC721Receiver} from "@openzeppelin/token/ERC721/IERC721Receiver.sol";
import {IERC721} from "@openzeppelin/token/ERC721/IERC721.sol";
import {Ownable2Step} from "@openzeppelin/access/Ownable2Step.sol";

interface IERC20Reward {
    function mint(address account, uint256 amount) external;
}

contract StakeOperator is IERC721Receiver, Ownable2Step {
    IERC20Reward public tokenReward;
    IERC721 public nftStaking;

    mapping(address owner => mapping(uint256 tokenId => uint256 claimed)) public dailyClaim;
    mapping(address owner => mapping(uint256 tokenId => uint256 locked)) public timeLock;

    event RecieveNFT(address indexed operator, address indexed from, uint256 tokenId);

    constructor(address _nftStaking) {
        nftStaking = IERC721(_nftStaking);
    }

    function setERC20Reward(address _tokenReward) external onlyOwner {
        tokenReward = IERC20Reward(_tokenReward);
    }

    function claimReward(uint256 tokenId) external {
        require(dailyClaim[msg.sender][tokenId] > 0, "StakeOperator: Already claimed");
        require(timeLock[msg.sender][tokenId] < block.timestamp, "StakeOperator: Claim not eligible yet");

        dailyClaim[msg.sender][tokenId] = 0;
        timeLock[msg.sender][tokenId] = 0;
        tokenReward.mint(msg.sender, 10 ether);

        nftStaking.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        require(msg.sender == address(nftStaking), "StakeOperator: Wrong staking asset");
        dailyClaim[from][tokenId] = 1;
        timeLock[from][tokenId] = block.timestamp + 1 days;
        emit RecieveNFT(operator, from, tokenId);
        return IERC721Receiver.onERC721Received.selector;
    }
}
